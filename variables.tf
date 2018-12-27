variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "key_name" {}
###### Variables for Base Infrastructure 
variable "ip_range" {}
variable "vpc_cidr" { default = "10.0.0.0/16"}
variable "availability_zones" {
default = ["eu-west-2a","eu-west-2b","eu-west-2c"]
}
variable "vpc_pub_subnet_ips" {
default = ["10.0.1.0/27", "10.0.2.0/27", "10.0.3.0/27"]}
variable "vpc_pri_subnet_ips" {
default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]}
variable "vpc_pub_subnet_names" {
 default = ["mypub_sub_2a", "mypub_sub_2b", "mypub_sub_2c"]
}
variable "vpc_pri_subnet_names" {
 default = ["mypri_sub_2a", "mypri_sub_2b", "mypri_sub_2c"]
}
########### Launch Config
variable "amis" {default = "ami-0274e11dced17bb5b"}
variable "instance_type" {
  default = "t2.micro"
}

##### Auto Scaling Groups
variable "asg_min" {
  default = "3"
}
variable "asg_max" {
  default = "3"
}

