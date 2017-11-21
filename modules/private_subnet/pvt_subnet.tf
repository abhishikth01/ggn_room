data "aws_vpc" "ggn_vpc_dev" {
  id = "vpc-b6806bde"
}

resource "aws_subnet" "pvt_sub" {
  vpc_id            = "${data.aws_vpc.ggn_vpc_dev.id}"
  availability_zone = "ap-south-1a"
  cidr_block        = "10.1.1.0/26"
  map_public_ip_on_launch = "false"

  tags {
    Name = "pvt_sub"
  }
}
