variable "availability_zones" {}
variable "asg_min" {
  default = "0"
}
variable "asg_max" {
  default = "0"
}
#
# From other modules
#
variable "public_subnets_id" {type="list"}
variable "mywebapp_lc_id" {}
variable "mywebapp_lc_name" {}
variable "mywebapp_elb_name" {}
