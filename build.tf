/*old file */

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "pub1" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  availability_zone = "us-east-1a"
  cidr_block        = "${cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 1)}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "sub_pub1"
  }
}


resource "aws_subnet" "pvt1" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  availability_zone = "us-east-1b"
  cidr_block        = "${cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 2)}"

  tags {
    Name = "sub_pvt1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "main"
  }
}

resource "aws_route_table" "pubrt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "pub_route"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.pub1.id}"
  route_table_id = "${aws_route_table.pubrt.id}"

}


resource "aws_network_acl" "main" {
  vpc_id = "${aws_vpc.my_vpc.id}"

    egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }


  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  subnet_ids = ["${aws_subnet.pub1.id}"]

  tags {
    Name = "main"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "web_sg"
  }
}






 resource "aws_instance" "web" {
  ami           = "${var.ami_id}"
  instance_type = "t2.micro"
  subnet_id      = "${aws_subnet.pub1.id}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.web_sg.id}"]

  tags {
   Name = "Hello CPT"
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "my_tf_test_bucket"
  acl    = "private"

  tags {
    Name        = "My bucket"
    Environment = "Lenovo"
  }
}