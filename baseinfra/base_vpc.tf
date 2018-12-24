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

resource "aws_cloudwatch_log_group" "my_vpc" {
  name = "my_vpc"
}

resource "aws_iam_role" "myvpc_role" {
  name = "my_vpc_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "my_vpc_log" {
  name = "my_vpc"
  role = "${aws_iam_role.myvpc_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_flow_log" "vpc_flologs" {
  iam_role_arn    = "${aws_iam_role.myvpc_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.my_vpc.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.my_vpc.id}"
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



### Create Private Subnets

resource "aws_subnet" "private_subnets" {
  count             = "${length(var.vpc_pri_subnet_ips)}"
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "${element(var.vpc_pri_subnet_ips, count.index)}"
  availability_zone = "${element(var.vpc_pri_subnet_azs, count.index)}"
  depends_on = ["aws_vpc.my_vpc"]
  tags {
    Name = "${element(var.vpc_pri_subnet_names, count.index)}"
  }
}
output "private_subnets_id" {
  value = ["${aws_subnet.private_subnets.*.id}"]
}


###### Create Nat Gateway
resource "aws_eip" "natip" {
vpc      = true
}
resource "aws_nat_gateway" "my_ngw" {
  allocation_id = "${aws_eip.natip.id}"
  subnet_id     = "${element(aws_subnet.public_subnets.*.id, 0)}"
  depends_on = ["aws_internet_gateway.my_igw"]

  tags = {
    Name = "my_ngw"
  }
}

### Create Private Route Table
resource "aws_route_table" "my_private_route_table" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = "${aws_nat_gateway.my_ngw.id}"
  }
  tags {
      Name = "my_private_route_table"
  }
}
output "my_private_route" {
  value = "${aws_route_table.my_private_route_table.id}"
}
resource "aws_route_table_association" "private_subnets" {
  count          = "${length(var.vpc_pri_subnet_ips)}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.my_private_route_table.id}"
}

# Network ACLs
### Create public nacl
resource "aws_network_acl" "pub-nacl" {
  vpc_id  = "${aws_vpc.my_vpc.id}"
  subnet_ids      = ["${aws_subnet.public_subnets.*.id}"]

  ingress = {
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }
  ingress = {
    protocol = "tcp"
    rule_no = 120
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }

  ingress = {
    protocol = "tcp"
    rule_no = 130
    action = "allow"
    cidr_block =  "${var.ip_range}"
    from_port = 22
    to_port = 22
  }
  ingress = {
    protocol = "tcp"
    rule_no = 140
    action = "allow"
    cidr_block =  "${var.ip_range}"
    from_port = 3389
    to_port = 3389
  }
  ingress = {
    protocol = "tcp"
    rule_no = 150
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }

  egress = {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "${var.vpc_cidr}"  
    from_port = 53
    to_port = 53
  }
  egress = {
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }

  egress = {
    protocol = "tcp"
    rule_no = 120
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }

  egress = {
    protocol = "tcp"
    rule_no = 130
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }
}
### Create Private nacl

resource "aws_network_acl" "pri-nacl" {
  vpc_id  = "${aws_vpc.my_vpc.id}"
  subnet_ids      = ["${aws_subnet.private_subnets.*.id}"]
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
    rule_no = 110
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
    protocol = "udp"
    rule_no = 100
    action = "allow"
    cidr_block = "${var.vpc_cidr}"  
    from_port = 53
    to_port = 53
  }
  egress = {
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }

  egress = {
    protocol = "tcp"
    rule_no = 120
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }

  egress = {
    protocol = "tcp"
    rule_no = 130
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }
}