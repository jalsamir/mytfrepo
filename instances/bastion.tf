resource "aws_instance" "bastion" {
  ami = "${var.image_id}"
  instance_type = "${var.instance_type}"
  tags = {
    Name = "my_bastion"
  }
  subnet_id = "${var.mypublic_subnet_id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${var.mybastion_ssh_sg_id}"]
  key_name = "${var.key_name}"
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}
