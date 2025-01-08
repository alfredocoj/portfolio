# Jenkins Disaster Recovery

This project automates the backup of Jenkins data using the Jenkins API. The backup files are securely stored in an Azure Storage Account, ensuring data integrity and availability. The solution is designed to be efficient and reliable, providing a seamless way to safeguard Jenkins configurations and job data.


## Technologies used

- **Jenkins API**: Used to get the list of jobs and export the job settings.
- **HashiCorp Vault**: Used to securely store credentials and configuration parameters.
- **Azure Storage Account**: Used to store compressed backup files.
- **Golang**: Programming language used to implement the solution.


## Estrutura de Pastas

```
jenkins-backup/
├── main.go 
├── go.mod 
├── go.sum 
└── README.md
```

## Environment configuration
### Dependencies
```
go mod tidy
```
### Environmental variables

- Windows Server:
```
$env:VAULT_TOKEN = "token-value"
$env:VAULT_URL = "http://127.0.0.1:8200"
$env:VAULT_SECRET_PATH = "secret/data/general/devops/devops"
```

- Linux Server:
```
export VAULT_TOKEN = "token-value"
export VAULT_URL = "http"
export VAULT_SECRET_PATH = "secret/data/general/devops/devops"
```

- Run code:
```
go run main.go
```

## Running the Code
1. Clone the Repository:
```
git clone https://github.com/seu-usuario/jenkins-backup.git
cd jenkins-backup
```
2. Install the Dependencies:
```
go mod tidy
```
3. Run the Code:
```
go run main.go
```

## How it works
1. *Obtaining Credentials:* The code fetches the credentials and configuration parameters stored in the HashiCorp Vault.
2. *Obtaining Jenkins Jobs:* Using the Jenkins API, the code obtains the list of jobs and exports the configuration files for each job.
3. *File compression:* The job configuration files are compressed into a ZIP file.
4. *Storage in Azure:* The ZIP file is sent to an Azure Storage Account.
5. *Local file removal:* Once the upload has been validated, the ZIP file is removed locally.

## Scheduling
The backup is scheduled to run daily using Golang's cron library. The schedule can be adjusted as needed in the code.

## Contributing
Improvements can be created through alerts to telegram channels and teams in the event of a failure during the backup process.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.