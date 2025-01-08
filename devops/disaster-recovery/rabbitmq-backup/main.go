package main

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"time"

	"github.com/Azure/azure-storage-blob-go/azblob"
	"github.com/hashicorp/vault/api"
	"github.com/robfig/cron/v3"
)

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
	rabbitmqUserName, ok := secretData["RABBITMQ_USER"].(string)
	if !ok || rabbitmqUserName == "" {
		log.Fatalf("RABBITMQ_USER is missing or not a string")
	}

	rabbitmqURL, ok := secretData["RABBITMQ_URL"].(string)
	if !ok || rabbitmqURL == "" {
		log.Fatalf("RABBITMQ_URL is missing or not a string")
	}

	rabbitmqPassword, ok := secretData["RABBITMQ_PASSWORD"].(string)
	if !ok || rabbitmqPassword == "" {
		log.Fatalf("RABBITMQ_PASSWORD is missing or not a string")
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
	return rabbitmqUserName, rabbitmqURL, rabbitmqPassword, accountName, accountKey, containerName
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

func exportRabbitMQConfig(rabbitmqUrl string, rabbitmqUser string, rabbitmqPassword string) error {
	url := fmt.Sprintf("%s/api/definitions", rabbitmqUrl)
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return err
	}

	req.SetBasicAuth(rabbitmqUser, rabbitmqPassword)
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	file, err := os.Create("config.json")
	if err != nil {
		return err
	}
	defer file.Close()
	_, err = io.Copy(file, resp.Body)
	return err
}

func uploadToAzureStorage(accountName string, containerName string, storageAccountKey string, fileName string) error {
	credential, err := azblob.NewSharedKeyCredential(accountName, storageAccountKey)
	if err != nil {
		return err
	}
	pipeline := azblob.NewPipeline(credential, azblob.PipelineOptions{})
	url, _ := url.Parse(fmt.Sprintf("https://%s.blob.core.windows.net/%s", accountName, containerName))
	containerURL := azblob.NewContainerURL(*url, pipeline)
	blobURL := containerURL.NewBlockBlobURL(fileName)
	file, err := os.Open(fileName)
	if err != nil {
		return err
	}
	defer file.Close()
	_, err = azblob.UploadFileToBlockBlob(context.Background(), file, blobURL, azblob.UploadToBlockBlobOptions{})
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
	rabbitmqUser, rabbitmqURL, rabbitmqPassword, accountName, accountKey, containerName := validateRequiredSecrets(secretData)

	// Continue with the rest of the code ...
	fmt.Println("All secrets retrieved successfully")

	c := cron.New()
	c.AddFunc("@midnight", func() {
		if err := exportRabbitMQConfig(rabbitmqURL, rabbitmqUser, rabbitmqPassword); err != nil {
			fmt.Println("Error exporting RabbitMQ config:", err)
		}
		timestamp := time.Now().Format("20060102-150405")
		randomHash, err := generateRandomHash()
		if err != nil {
			fmt.Println("Error generating random hash:", err)
			return
		}
		newFileName := fmt.Sprintf("config-%s-%s.json", timestamp, randomHash)
		if err := os.Rename("config.json", newFileName); err != nil {
			fmt.Println("Error renaming config.json:", err)
		}

		if err := uploadToAzureStorage(accountName, containerName, accountKey, newFileName); err != nil {
			fmt.Println("Error uploading config.json to Azure Storage:", err)
		}
		fmt.Printf("Rabbitmq backuped successfully: %s \n", newFileName)

		err = os.Remove(newFileName)
		if err != nil {
			fmt.Printf("Error removing loccaly %s file: %v\n", newFileName, err)
		}
		fmt.Printf("%s file removed loccaly successfully\n", newFileName)
	})
	c.Start()
	select {}
}
