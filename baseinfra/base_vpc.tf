### Create VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
      Name = "my_vpc"
  }
}
output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

### Create Internet Gateway

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "my_igw"
  }
}


### Create Public Subnet
resource "aws_subnet" "my_public_subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${element(var.availability_zones, 0)}"
  tags {
      Name = "my_public_subnet"
  }
}
output "public_subnet_id" {
  value = "${aws_subnet.my_public_subnet.id}"
}

### Create Public Route Table
resource "aws_route_table" "my_public_route" {
  vpc_id = "${aws_vpc.default.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
      Name = "my_public_subnet_route_table"
  }
}
### Associating Subnet to RouteTable
resource "aws_route_table_association" "my_public_r_table" {
  subnet_id = "${aws_subnet.my_public_subnet.id}"
  route_table_id = "${aws_route_table.my_public_route.id}"
}

