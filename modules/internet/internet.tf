data "aws_vpc" "ggn_vpc_dev" {
  id = "vpc-b6806bde"
}

data "aws_subnet" "ggn_dmc1" {
  id = "subnet-c0ad5ea8"
}
data "aws_subnet" "ggn_dmc2" {
  id = "subnet-c0ad5ea8"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${data.aws_vpc.ggn_vpc_dev.id}"

  tags {
    Name = "main"
  }
}

resource "aws_route_table" "pubrt1" {
  vpc_id = "${data.aws_vpc.ggn_vpc_dev.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "pub_route"
  }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = "${data.aws_subnet.ggn_dmc1.id}"
  route_table_id = "${aws_route_table.pubrt1.id}"

}

resource "aws_route_table_association" "a2" {
  subnet_id      = "${data.aws_subnet.ggn_dmc2.id}"
  route_table_id = "${aws_route_table.pubrt1.id}"

}