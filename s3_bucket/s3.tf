resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "my-app-testing-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name        = "My App Test Bucket"
    Environment = "test"
  }
}
resource "aws_s3_bucket_policy" "my_s3_bucket" {
  bucket = "${aws_s3_bucket.my_s3_bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::my-app-testing-bucket/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      }
    }
  ]
}
POLICY
}