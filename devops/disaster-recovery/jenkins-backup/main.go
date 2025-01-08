package main

import (
	"archive/zip"
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"time"

	"github.com/Azure/azure-storage-blob-go/azblob"
	"github.com/hashicorp/vault/api"
	"github.com/robfig/cron/v3"
)

type JenkinsJob struct {
	Name string `json:"name"`
	URL  string `json:"url"`
}

type JenkinsResponse struct {
	Jobs []JenkinsJob `json:"jobs"`
}

func loadEnvironments() map[string]interface{} {
	config := api.DefaultConfig()

	if os.Getenv("VAULT_URL") == "" {
		log.Fatalf("VAULT_URL environment variable is not set")
	}
	config.Address = os.Getenv("VAULT_URL")

	client, err := api.NewClient(config)
	if err != nil {
		log.Fatalf("Erro ao criar cliente Vault: %v", err)
	}

	vaultToken := os.Getenv("VAULT_TOKEN")
	if vaultToken == "" {
		log.Fatalf("VAULT_TOKEN environment variable is not set")
	}
	client.SetToken(vaultToken)

	vaultSecretPath := os.Getenv("VAULT_SECRET_PATH")

	secretData, err := getVaultSecret(client, vaultSecretPath)
	if err != nil {
		fmt.Printf("Error getting secret from Vault: %v\n", err)
		os.Exit(1)
	}
	return secretData
}

func validateRequiredSecrets(secretData map[string]interface{}) (string, string, string, string, string, string) {
	username, ok := secretData["JENKINS_USER"].(string)
	if !ok || username == "" {
		log.Fatalf("JENKINS_USER is missing or not a string")
	}

	jenkinsURL, ok := secretData["JENKINS_URL"].(string)
	if !ok || jenkinsURL == "" {
		log.Fatalf("JENKINS_URL is missing or not a string")
	}

	apiToken, ok := secretData["JENKINS_API_TOKEN"].(string)
	if !ok || apiToken == "" {
		log.Fatalf("JENKINS_API_TOKEN is missing or not a string")
	}

	accountName, ok := secretData["STORAGE_ACCOUNT_NAME"].(string)
	if !ok || accountName == "" {
		log.Fatalf("STORAGE_ACCOUNT_NAME is missing or not a string")
	}

	accountKey, ok := secretData["STORAGE_ACCOUNT_KEY"].(string)
	if !ok || accountKey == "" {
		log.Fatalf("STORAGE_ACCOUNT_KEY is missing or not a string")
	}

	containerName, ok := secretData["STORAGE_ACCOUNT_CONTAINER_NAME"].(string)
	if !ok || containerName == "" {
		log.Fatalf("STORAGE_ACCOUNT_CONTAINER_NAME is missing or not a string")
	}
	return username, jenkinsURL, apiToken, accountName, accountKey, containerName
}

func getVaultSecret(client *api.Client, secretPath string) (map[string]interface{}, error) {
	secret, err := client.Logical().Read(secretPath)
	if err != nil {
		return nil, err
	}
	if secret == nil {
		return nil, fmt.Errorf("no secret found at path: %s", secretPath)
	}
	return secret.Data["data"].(map[string]interface{}), nil
}

func getJenkinsJobs(jenkinsURL, username, apiToken string) ([]JenkinsJob, error) {
	client := &http.Client{}
	req, err := http.NewRequest("GET", fmt.Sprintf("%s/api/json", jenkinsURL), nil)
	if err != nil {
		return nil, err
	}

	req.SetBasicAuth(username, apiToken)
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("failed to get jobs: %s", resp.Status)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var jenkinsResponse JenkinsResponse
	err = json.Unmarshal(body, &jenkinsResponse)
	if err != nil {
		return nil, err
	}

	return jenkinsResponse.Jobs, nil
}

func exportJenkinsJob(jenkinsURL, username, apiToken, jobName string) ([]byte, error) {
	client := &http.Client{}
	jobURL := fmt.Sprintf("%s/job/%s/config.xml", jenkinsURL, jobName)
	req, err := http.NewRequest("GET", jobURL, nil)
	if err != nil {
		return nil, err
	}

	req.SetBasicAuth(username, apiToken)
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("failed to get job config: %s", resp.Status)
	}

	return io.ReadAll(resp.Body)
}

func createZipFile(jobConfigs map[string][]byte, zipFilePath string) error {
	zipFile, err := os.Create(zipFilePath)
	if err != nil {
		return err
	}
	defer zipFile.Close()

	zipWriter := zip.NewWriter(zipFile)
	for jobName, config := range jobConfigs {
		f, err := zipWriter.Create(fmt.Sprintf("%s.xml", jobName))
		if err != nil {
			return err
		}
		_, err = f.Write(config)
		if err != nil {
			return err
		}
	}

	err = zipWriter.Close()
	if err != nil {
		return err
	}

	return nil
}

func uploadToAzureStorage(accountName, accountKey, containerName, blobName, filePath string) error {
	credential, err := azblob.NewSharedKeyCredential(accountName, accountKey)
	if err != nil {
		return err
	}

	p := azblob.NewPipeline(credential, azblob.PipelineOptions{})
	URL, _ := url.Parse(fmt.Sprintf("https://%s.blob.core.windows.net/%s", accountName, containerName))
	containerURL := azblob.NewContainerURL(*URL, p)
	blobURL := containerURL.NewBlockBlobURL(blobName)

	ctx := context.Background()
	file, err := os.Open(filePath)
	if err != nil {
		return err
	}
	defer file.Close()

	_, err = azblob.UploadFileToBlockBlob(ctx, file, blobURL, azblob.UploadToBlockBlobOptions{})
	return err
}

func generateRandomHash() (string, error) {
	bytes := make([]byte, 16)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

func main() {

	// Load secrets from Vault
	secretData := loadEnvironments()

	// Check that the keys exist and are not nil
	username, jenkinsURL, apiToken, accountName, accountKey, containerName := validateRequiredSecrets(secretData)

	// Continue with the rest of the code ...
	fmt.Println("All secrets retrieved successfully")

	c := cron.New()
	c.AddFunc("@midnight", func() {
		jobs, err := getJenkinsJobs(jenkinsURL, username, apiToken)
		if err != nil {
			fmt.Println("Error getting Jenkins jobs:", err)
			return
		}

		jobConfigs := make(map[string][]byte)
		for _, job := range jobs {
			config, err := exportJenkinsJob(jenkinsURL, username, apiToken, job.Name)
			if err != nil {
				fmt.Println("Error exporting Jenkins job:", err)
				continue
			}
			jobConfigs[job.Name] = config
		}
		fmt.Println("Jenkins jobs config exported successfully")

		timestamp := time.Now().Format("20060102-150405")
		randomHash, err := generateRandomHash()
		if err != nil {
			fmt.Println("Error generating random hash:", err)
			return
		}

		zipFileName := fmt.Sprintf("jenkins-jobs-backup-%s-%s.zip", timestamp, randomHash)
		zipFilePath := filepath.Join(os.TempDir(), zipFileName)

		err = createZipFile(jobConfigs, zipFilePath)
		if err != nil {
			fmt.Println("Error creating ZIP file:", err)
			return
		}
		fmt.Println("Jenkins Jobs compacted successfully:", zipFileName)

		err = uploadToAzureStorage(accountName, accountKey, containerName, zipFileName, zipFilePath)
		if err != nil {
			fmt.Println("Error uploading to Azure Storage:", err)
			return
		}
		fmt.Println("Jenkins Jobs backuped successfully")

		err = os.Remove(zipFilePath)
		if err != nil {
			fmt.Println("Error removing local ZIP file:", err)
		}
		fmt.Println("ZIP file removed loccaly successfully")
	})

	c.Start()

	select {} // Keep the program running
}
