# RabbitMQ Disaster Recovery

This project automates the backup of RabbitMQ data using the RabbitMQ API. The backup files are stored securely in an Azure Storage Account, ensuring data integrity and availability. The solution is designed to be efficient and reliable, providing a seamless way to protect RabbitMQ configurations and messages.

## Technologies Used

- **RabbitMQ API**: Used to obtain the RabbitMQ settings and messages.
- **HashiCorp Vault**: Used to securely store credentials and configuration parameters.
- Azure Storage Account**: Used to store the compressed backup files.
- Golang**: Programming language used to implement the solution.


## Folder Structure
```
rabbitmq-backup/
├── main.go
├── go.mod
├── go.sum
└── README.md
```

## Environment Configuration

### Dependencies

To manage the project's dependencies, run:
```
go mod tidy
```

## Environmental variables
- Windows Server
```
$env:VAULT_TOKEN = "token-value"
$env:VAULT_URL = "http://127.0.0.1:8200"
$env:VAULT_SECRET_PATH = "secret/data/rabbitmq"
```

- Linux Server:
```
export VAULT_TOKEN = "token-value"
export VAULT_URL = "https://vault-dev.grupomateus.com.br"
export VAULT_SECRET_PATH = "secret/data/general/devops/devops"
```

## Running the Code

1. **Clone the Repository:**
```
git clone https://github.com/seu-usuario/rabbitmq-backup.git
cd rabbitmq-backup
```

2. **Install the Dependencies:**
```
go mod tidy
```

3. **Run the Code:**
```
go run main.go
```

## Operation
1. **Obtaining Credentials:** The code fetches the credentials and configuration parameters stored in the HashiCorp Vault.
2. **Obtaining RabbitMQ data:** Using the RabbitMQ API, the code obtains the configurations and messages.
3. **File compression:** The RabbitMQ data is compressed into a ZIP file.
4. **Azure Storage:** The ZIP file is sent to an Azure Storage Account.
5. **Local File Removal:** Once the upload has been validated, the ZIP file is removed locally.

## Scheduling
The backup is scheduled to run daily using Golang's cron library. The schedule can be adjusted as needed in the code.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.