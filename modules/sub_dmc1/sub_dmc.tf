data "aws_vpc" "ggn_vpc"
  id = "vpc-cdb259a5"

resource "aws_subnet" "dmc1" {
  vpc_id            = "${aws_vpc.ggn_vpc.id}"
  availability_zone = "ap-south-1a"
  cidr_block        = "10.1.0.0/28"
  map_public_ip_on_launch = "true"

  tags {
    Name = "sub_dmc1"
  }
}