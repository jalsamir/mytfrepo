provider "aws"{
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
module "baseinfra" {
  source = "./baseinfra"
  ip_range = "${var.ip_range}"
}
module "s3_bucket" {
  source = "./s3_bucket"
  vpc_id = "${module.baseinfra.vpc_id}"
}
module "launch_configurations" {
  source = "./launch_configurations"
  mywebapp_http_inbound_sg_id = "${module.baseinfra.mywebapp_http_inbound_sg_id}"
  mywebapp_ssh_inbound_sg_id = "${module.baseinfra.mywebapp_ssh_inbound_sg_id}"
  mywebapp_outbound_sg_id = "${module.baseinfra.mywebapp_outbound_sg_id}"
  key_name = "${var.key_name}"
  amis = "${var.amis}"
}

module "load_balancers" {
  source = "./load_balancers"
  availability_zones = "${var.availability_zones}"
  public_subnets_id = ["${module.baseinfra.public_subnets_id}"]
  mywebapp_http_inbound_sg_id = "${module.baseinfra.mywebapp_http_inbound_sg_id}"
  elb_log_s3 = "${module.s3_bucket.elblogs}"
  vpc_id = "${module.baseinfra.vpc_id}"
}
module "autoscaling_groups" {
  source = "./autoscaling_groups"
  availability_zones = "${var.availability_zones}"
  private_subnets_id = ["${module.baseinfra.private_subnets_id}"]
  mywebapp_lc_id = "${module.launch_configurations.mywebapp_lc_id}"
  mywebapp_lc_name = "${module.launch_configurations.mywebapp_lc_name}"
  mywebapp_elb_name = "${module.load_balancers.mywebapp_elb_name}"
}