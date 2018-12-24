variable "availability_zones" {}

#
# From other modules
#
variable "public_subnets_id" {type="list"}
variable "mywebapp_http_inbound_sg_id" {}
variable "elb_log_s3" {}
variable "vpc_id" {}
