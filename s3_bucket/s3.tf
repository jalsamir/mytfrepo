resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "my-app-testing-bucket"
  acl    = "private"
  region = "${var.region}"
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

resource "aws_s3_bucket_object" "index" {
    bucket = "${aws_s3_bucket.my_s3_bucket.id}"
    key = "index.html"
    source = "./s3_bucket/index.html"

    depends_on = ["aws_s3_bucket.my_s3_bucket"]
}
resource "aws_s3_bucket_object" "az2a" {
    bucket = "${aws_s3_bucket.my_s3_bucket.id}"
    key = "AZ2A.html"
    source = "./s3_bucket/AZ2A.html"

    depends_on = ["aws_s3_bucket.my_s3_bucket"]
}
resource "aws_s3_bucket_object" "az2b" {
    bucket = "${aws_s3_bucket.my_s3_bucket.id}"
    key = "AZ2B.html"
    source = "./s3_bucket/AZ2B.html"

    depends_on = ["aws_s3_bucket.my_s3_bucket"]
}
resource "aws_s3_bucket_object" "az2c" {
    bucket = "${aws_s3_bucket.my_s3_bucket.id}"
    key = "AZ2C.html"
    source = "./s3_bucket/AZ2C.html"

    depends_on = ["aws_s3_bucket.my_s3_bucket"]
}


resource "aws_s3_bucket" "elblogs" {
	bucket = "mywebapp-elb-logs"
	acl    = "private"
	region = "${var.region}"
}
data "aws_elb_service_account" "main" {}
resource "aws_s3_bucket_policy" "elblogs" {
  bucket = "${aws_s3_bucket.elblogs.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "AWSConsole-AccessLogs-Policy-1545414334554",
    "Statement": [
        {
            "Sid": "AWSConsoleStmt-1545414334554",
            "Effect": "Allow",
            "Principal": {
                "AWS": ["${data.aws_elb_service_account.main.arn}"]
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::mywebapp-elb-logs/AWSLogs/987933085652/*"
        },
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::mywebapp-elb-logs/AWSLogs/987933085652/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::mywebapp-elb-logs"
        }
    ]
}
POLICY
}
output "elblogs" {
	value = "${aws_s3_bucket.elblogs.bucket}"
}
output "elb_s3_bucket_arn" {
	value = "${aws_s3_bucket.elblogs.arn}"
}
