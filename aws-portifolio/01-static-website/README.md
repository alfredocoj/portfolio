# Static Website Provisioning with AWS

## Overview

This project demonstrates how to provision resources for a static website using AWS services such as Route 53, CloudFront, Lambda@Edge, and S3. The goal is to create a highly available, scalable, and secure static website hosted on AWS. This project serves as a portfolio to showcase my knowledge and skills in AWS infrastructure as code (IaC) using Terraform.

## Project Structure

The project is organized into several Terraform configuration files, each responsible for different aspects of the infrastructure:

```
.
├── README.md
├── img
├── terraform/
├──── main.tf
├──── variables.tf
├──── outputs.tf
├──── providers.tf
├──── s3.tf
├──── cloudfront.tf
└──── terraform.tfvars
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
**Date**: 01-04-2025