variable "root_domain_bucket_name" {
  description = "The name of the root domain S3 bucket"
  type        = string
  default     = "example.com"
}

variable "subdomain_bucket_name" {
  description = "The name of the subdomain S3 bucket"
  type        = string
  default     = "www.example.com"
}

variable "cloudfront_comment" {
  description = "Comment for the CloudFront distribution"
  type        = string
  default     = "Static website CDN"
}


variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "domain_name" {
  description = "The domain name for the Route 53 zone"
  type        = string

}

variable "record_name" {
  description = "The domain name for the Route 53 zone"
  type        = string
  default     = "www"
}

variable "record_type" {
  description = "The record type for the Route 53 record"
  type        = string
  default     = "A"
}
