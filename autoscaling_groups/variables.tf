variable "availability_zones" {}
variable "asg_min" {
  default = "3"
}
variable "asg_max" {
  default = "3"
}
#
# From other modules
#
variable "private_subnets_id" {type="list"}
variable "mywebapp_lc_id" {}
variable "mywebapp_lc_name" {}
variable "mywebapp_elb_name" {}
