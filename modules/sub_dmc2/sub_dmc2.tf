data "aws_vpc" "ggn_vpc_dev" {
  id = "vpc-b6806bde"
}

resource "aws_subnet" "dmc2" {
  vpc_id            = "${data.aws_vpc.ggn_vpc_dev.id}"
  availability_zone = "ap-south-1a"
  cidr_block        = "10.1.0.16/28"
  map_public_ip_on_launch = "true"

  tags {
    Name = "sub_dmc2"
  }
}
