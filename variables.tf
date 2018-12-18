variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "ip_range" {
  default = "10.11.0.0/16" 
}
variable "availability_zones" {
  # No spaces allowed between az names!
  default = ["eu-west-2a","eu-west-2b","eu-west-2c"]
}
