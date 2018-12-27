variable key_name  {}
variable "instance_type" {}
variable "amis" {}
#
# From other modules
#
variable "mywebapp_http_inbound_sg_id" {}
variable "mywebapp_ssh_inbound_sg_id" {}
variable "mywebapp_outbound_sg_id" {}
