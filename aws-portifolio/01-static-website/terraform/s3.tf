resource "aws_s3_bucket" "root_domain_bucket" {
  bucket = var.root_domain_bucket_name
}

resource "aws_s3_bucket_acl" "root_domain_bucket_acl" {
  bucket = aws_s3_bucket.root_domain_bucket.id
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
  policy = data.aws_iam_policy_document.root_domain_policy_doc.json
}

data "aws_iam_policy_document" "root_domain_policy_doc" {
  statement {
    actions   = ["s3:GetObject","s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.root_domain_bucket_name}/*"]
    principals {
      type        = "AWS"
      identifiers = ["13356567890"]
    }
  }
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
}

resource "aws_s3_bucket_acl" "subdomain_bucket_acl" {
  bucket = aws_s3_bucket.subdomain_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "subdomain_policy" {
  bucket = aws_s3_bucket.subdomain_bucket.id
  policy = data.aws_iam_policy_document.subdomain_domain_policy_doc.json
}

data "aws_iam_policy_document" "subdomain_domain_policy_doc" {
  statement {
    actions   = ["s3:GetObject","s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.subdomain_bucket_name}/*"]
    principals {
      type        = "AWS"
      identifiers = ["13356567124"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "subdomain_block" {
  bucket = aws_s3_bucket.subdomain_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
