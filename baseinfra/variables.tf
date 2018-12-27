variable "ip_range" {}
variable "vpc_cidr" {}
variable "availability_zones" {type = "list"}
variable "vpc_pub_subnet_ips" {type = "list"}
variable "vpc_pri_subnet_ips" {type = "list"}
variable "vpc_pub_subnet_names" {type = "list"}
variable "vpc_pri_subnet_names" {type = "list"}

