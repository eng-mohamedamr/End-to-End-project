output "bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.frontend.arn
}