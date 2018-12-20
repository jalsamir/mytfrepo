variable "region" {}
variable "key_name" {}
variable "image_id" {}
variable "instance_type" {}
#
# From other modules
#
variable "mypublic_subnet_id" {}
variable "mybastion_ssh_sg_id" {}
variable "myprivate_subnet_id" {}
variable "myssh_from_bastion_sg_id" {}
variable "myweb_access_from_nat_sg_id" {}
