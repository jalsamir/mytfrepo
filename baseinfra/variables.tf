variable "ip_range" {}
variable "availability_zones" {
  # No spaces allowed between az names!
  default = ["eu-west-2a","eu-west-2b","eu-west-2c"]
}
variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.11.0.0/16"
}
variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default = "10.11.0.0/24"
}
variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default = "10.11.1.0/24"
}
