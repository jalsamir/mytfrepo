resource "aws_iam_role" "myapp_iam_role" {
    name = "myapp_iam_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "myapp_instance_profile" {
    name = "myapp_web_instance_profile"
    role = "${aws_iam_role.myapp_iam_role.name}"
}

resource "aws_iam_role_policy" "myapp_iam_role_policy" {
  name = "myapp_iam_role_policy"
  role = "${aws_iam_role.myapp_iam_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::my-app-testing-bucket"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::my-app-testing-bucket/*"]
    }
  ]
}
EOF
}
resource "aws_launch_configuration" "mywebapp_lc" {
  lifecycle { create_before_destroy = true }
  image_id = "${var.amis}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.myapp_instance_profile.id}"
  associate_public_ip_address = false
  security_groups = [
    "${var.mywebapp_http_inbound_sg_id}",
    "${var.mywebapp_ssh_inbound_sg_id}",
    "${var.mywebapp_outbound_sg_id}"
  ]
  #user_data = "${file("./launch_configurations/userdata.sh")}"
  user_data = <<-EOF
			#!/bin/bash
			yum -y install httpd
			service httpd start
			chkconfig httpd on
			EOF
  key_name = "${var.key_name}"
}
output "mywebapp_lc_id" {
  value = "${aws_launch_configuration.mywebapp_lc.id}"
}
output "mywebapp_lc_name" {
  value = "${aws_launch_configuration.mywebapp_lc.name}"
}
