variable "availability_zones" {}
variable "asg_min" {
  default = "1"
}
variable "asg_max" {
  default = "1"
}
#
# From other modules
#
variable "private_subnets_id" {type="list"}
variable "mywebapp_lc_id" {}
variable "mywebapp_lc_name" {}
variable "mywebapp_elb_name" {}
