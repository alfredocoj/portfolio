# Lambda@Edge
The Lambda@Edge function will be used to add security headers to CloudFront responses. This will improve site security by adding headers such as Content-Security-Policy, Strict-Transport-Security, X-Content-Type-Options, X-Frame-Options, and X-XSS-Protection.

## Steps to Implement the Lambda Function
- Create the Lambda Function: Write the Lambda function that adds the security headers.
- Package the Function: Package the Lambda function in a lambda_function.zip file.
- Reference the Function in Terraform: Update the cloudfront.tf file to reference the Lambda function.