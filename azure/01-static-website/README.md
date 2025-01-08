# Static Website Provisioning with AWS

## Overview

This project demonstrates how to provision resources for a static website using Azure services such as Azure Front Door, Storage Account, Frontend Endpoint and Route Engine. The goal is to create a highly available, scalable, and secure static website hosted on Azure. This project serves as a portfolio to showcase my knowledge and skills in Azure infrastructure as code (IaC) using Terraform.

The following diagram illustrates the architectural model:

![Static website design architectural model.](./img/project01.png)

Here is how the process works:

1. Viewer requests website `www.example.com`.
2, Requets DNS service for Route 53.
3. If the object is cached already, CloudFront returns the object from the cache to the viewer, otherwise it moves on to step 4.
4. CloudFront requests the object from the origin, in this case an S3 bucket.
5. S3 returns the object, which in turn causes CloudFront to trigger the origin response event.
6. Our Add Security Headers Lambda function triggers, and the resulting output is cached and served by CloudFront.

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

### File Descriptions

- **main.tf**: The main configuration file that includes the overall setup and orchestration of resources.
- **variables.tf**: Defines all the variables used in the project, allowing for easy customization and reusability.
- **outputs.tf**: Specifies the outputs of the Terraform run, providing important information about the created resources.
- **providers.tf**: Configures the providers (e.g., AWS) used in the project.
- **s3.tf**: Contains the configuration for the S3 buckets used to host the static website.
- **cloudfront.tf**: Contains the configuration for the CloudFront distribution used to serve the static website.
- **terraform.tfvars**: Provides the values for the variables defined in `variables.tf`.

## Resources Provisioned

### S3 Buckets

- **Root Domain Bucket**: Hosts the static website content.
- **Subdomain Bucket**: Optionally hosts content for a subdomain.

### CloudFront Distribution

- **CDN**: Distributes the static website content globally with low latency and high transfer speeds.

### Route 53

- **DNS**: Manages the DNS records for the domain and subdomain.

### Lambda@Edge

- **Permissions**: Configures Lambda@Edge permissions for custom logic at the edge locations.

## Usage

1. **Install Terraform**: Ensure you have Terraform installed on your machine.
2. **Configure AWS CLI**: Set up your AWS CLI with the necessary credentials.
3. **Initialize Terraform**: Run `terraform init` to initialize the project.
4. **Apply Configuration**: Run `terraform apply` to provision the resources.

## Conclusion

This project demonstrates the use of Terraform to provision a static website on AWS, leveraging various AWS services to achieve a robust and scalable solution. It showcases my ability to use infrastructure as code to manage and deploy cloud resources efficiently.

Feel free to explore the code and adapt it to your own needs. If you have any questions or suggestions, please feel free to reach out.

---


**Author**: Alfredo Costa Oliveira Junior

**E-mail**: [alfredo.coj@gmail.com](mailto:alfredo.coj@gmail.com)

**Date**: 01-06-2025