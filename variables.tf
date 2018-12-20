variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "key_name" {}
variable "ip_range" {}
variable "availability_zones" {
  default = ["eu-west-2a","eu-west-2b","eu-west-2c"]
}
variable "amis" {}

