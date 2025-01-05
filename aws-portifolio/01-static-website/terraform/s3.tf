resource "aws_s3_bucket" "root_domain_bucket" {
  bucket = var.root_domain_bucket_name
  acl    = "public-read"

}

resource "aws_s3_bucket_website_configuration" "root_domain_bucket_config" {
  bucket = aws_s3_bucket.root_domain_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "root_domain_policy" {
  bucket = aws_s3_bucket.root_domain_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "arn:aws:s3:::example.com/*"
    }]
  })
}

resource "aws_s3_bucket_public_access_block" "root_domain_block" {
  bucket = aws_s3_bucket.root_domain_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket" "subdomain_bucket" {
  bucket = var.subdomain_bucket_name
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "subdomain_policy" {
  bucket = aws_s3_bucket.subdomain_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "arn:aws:s3:::www.example.com/*"
    }]
  })
}

resource "aws_s3_bucket_public_access_block" "subdomain_block" {
  bucket = aws_s3_bucket.subdomain_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
