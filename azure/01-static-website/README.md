# Static Website Provisioning with AWS

## Overview

This project demonstrates how to provision resources for a static website using Azure services such as Azure Front Door, Storage Account, Frontend Endpoint and Route Engine. The goal is to create a highly available, scalable, and secure static website hosted on Azure. This project serves as a portfolio to showcase my knowledge and skills in Azure infrastructure as code (IaC) using Terraform.

The following diagram illustrates the architectural model:

![Static website design architectural model.](./img/project01.png)

Here is how the process works:

1. Viewer requests website `www.example.com`.
2. The request is routed through Azure Front Door.
3. If the object is cached already, Azure Front Door returns the object from the cache to the viewer, otherwise it moves on to step 4.
4. Azure Front Door requests the object from the origin, in this case, an Azure Storage Account.
5. The Storage Account returns the object, which in turn causes Azure Front Door to trigger the origin response event.
6. The resulting output is cached and served by Azure Front Door.

## Project Structure

The project is organized into several Terraform configuration files, each responsible for different aspects of the infrastructure:

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf
└── modules/
    └── storage_account/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

- **main.tf**: The main configuration file that includes the overall setup and orchestration of resources.
- **variables.tf**: Defines all the variables used in the project, allowing for easy customization and reusability.
- **outputs.tf**: Specifies the outputs of the Terraform run, providing important information about the created resources.
- **providers.tf**: Configures the providers (e.g., Azure) used in the project.
- **storage_account.tf**: Contains the configuration for the Azure Storage Account used to host the static website.
- **front_door.tf**: Contains the configuration for the Azure Front Door distribution used to serve the static website.
- **terraform.tfvars**: Provides the values for the variables defined in `variables.tf`.

## Resources Provisioned

### Azure Storage Account

- **Root Domain Storage**: Hosts the static website content.
- **Subdomain Storage**: Optionally hosts content for a subdomain.

### Azure Front Door

- **CDN**: Distributes the static website content globally with low latency and high transfer speeds.

### Azure DNS

- **DNS**: Manages the DNS records for the domain and subdomain.

## Usage

1. **Install Terraform**: Ensure you have Terraform installed on your machine.
2. **Configure Azure CLI**: Set up your Azure CLI with the necessary credentials.
3. **Initialize Terraform**: Run `terraform init` to initialize the project.
4. **Apply Configuration**: Run `terraform apply` to provision the resources.

## Conclusion

This project demonstrates the use of Terraform to provision a static website on Azure, leveraging various Azure services to achieve a robust and scalable solution. It showcases my ability to use infrastructure as code to manage and deploy cloud resources efficiently.

Feel free to explore the code and adapt it to your own needs. If you have any questions or suggestions, please feel free to reach out.

---

**Author**: Alfredo Costa Oliveira Junior

**E-mail**: [alfredo.coj@gmail.com](mailto:alfredo.coj@gmail.com)

**Date**: 01-06-2025