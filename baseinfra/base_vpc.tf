### Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
      Name = "my_vpc"
  }
}
output "vpc_id" {
  value = "${aws_vpc.my_vpc.id}"
}

### Create Internet Gateway

resource "aws_internet_gateway" "my_igw" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  tags {
      Name = "my_igw"
  }
}


### Create Public Subnets

resource "aws_subnet" "public_subnets" {
  count             = "${length(var.vpc_pub_subnet_ips)}"
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "${element(var.vpc_pub_subnet_ips, count.index)}"
  availability_zone = "${element(var.vpc_pub_subnet_azs, count.index)}"
  depends_on = ["aws_vpc.my_vpc"]
  tags {
    Name = "${element(var.vpc_pub_subnet_names, count.index)}"
  }
}
output "public_subnets_id" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

### Create Public Route Table
resource "aws_route_table" "my_public_route_table" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.my_igw.id}"
  }
  tags {
      Name = "my_public_route_table"
  }
}
output "my_public_route" {
  value = "${aws_route_table.my_public_route_table.id}"
}
resource "aws_route_table_association" "public_subnets" {
  count          = "${length(var.vpc_pub_subnet_ips)}"
  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.my_public_route_table.id}"
}


# Network ACLs

resource "aws_network_acl" "pub-nacl" {
  vpc_id  = "${aws_vpc.my_vpc.id}"
  subnet_ids      = ["${aws_subnet.public_subnets.*.id}"]

  ingress = {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }

  ingress = {
    protocol = "tcp"
    rule_no = 101
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }

  ingress = {
    protocol = "tcp"
    rule_no = 120
    action = "allow"
    cidr_block =  "${var.ip_range}"
    from_port = 22
    to_port = 22
  }
  ingress = {
    protocol = "tcp"
    rule_no = 130
    action = "allow"
    cidr_block =  "${var.ip_range}"
    from_port = 3389
    to_port = 3389
  }
  ingress = {
    protocol = "tcp"
    rule_no = 140
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }

  egress = {
    protocol = "tcp"
    rule_no = 101
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }

  egress = {
    protocol = "tcp"
    rule_no = 102
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }

  egress = {
    protocol = "tcp"
    rule_no = 103
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }
}
