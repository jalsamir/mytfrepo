provider "aws"{
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
module "baseinfra" {
  source = "./baseinfra"
  ip_range = "${var.ip_range}"
}
