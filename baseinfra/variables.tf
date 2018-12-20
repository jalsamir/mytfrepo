variable "ip_range" {}
variable "availability_zones" {
  # No spaces allowed between az names!
  default = ["eu-west-2a","eu-west-2b","eu-west-2c"]
}
variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.11.0.0/16"
}

variable "vpc_pub_subnet_ips" { 

  default = ["10.11.1.0/24", "10.11.2.0/24", "10.11.3.0/24"]
}

variable "vpc_pub_subnet_names" {

 default = ["mypub_sub_2a", "mypub_sub_2b", "mypub_sub_2c"]
}
variable "vpc_pub_subnet_azs" {

 default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}
