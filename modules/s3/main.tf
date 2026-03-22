provider "aws" {
    region = "ap-northeast-2" 
}

resource "aws_s3_bucket" "my_s3" {
    bucket = "tanu-111"
}
resource "s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.my_s3.id
  
    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "error.html"
    }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_s3.id

  block_public_acls   = true
  block_public_policy = true
}
output "aws_s3_bucket_website_endpoint" {
  value       = aws_s3_bucket.my_s3.website_endpoint
}