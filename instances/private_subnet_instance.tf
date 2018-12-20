resource "aws_instance" "private_subnet_instance" {
  ami = "${var.image_id}"
  instance_type = "${var.instance_type}"
  tags = {
    Name = "My_private_instance"
  }
  subnet_id = "${var.myprivate_subnet_id}"
  vpc_security_group_ids = [
    "${var.myssh_from_bastion_sg_id}",
    "${var.myweb_access_from_nat_sg_id}"
    ]
  key_name = "${var.key_name}"
}
