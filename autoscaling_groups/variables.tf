variable "availability_zones" {}
variable "asg_min" {}
variable "asg_max" {}
#
# From other modules
#
variable "private_subnets_id" {type="list"}
variable "mywebapp_lc_id" {}
variable "mywebapp_lc_name" {}
variable "mywebapp_elb_name" {}
