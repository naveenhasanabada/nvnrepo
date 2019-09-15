#creation of network components

resource "aws_vpc" "nvn_vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "nvn_vpc" }
 # route_table_id = "${aws_route_table.nvn_rt.id}"
}


resource "aws_subnet" "nvn_subnet" {

  ##cidr_block        = "${cidrsubnet(data.aws_vpc.target.cidr_block, 4, lookup(var.az_numbers, data.aws_availability_zone.target.name_suffix))}"
  cidr_block = "${var.subnet_cidr_block}"
  vpc_id     = "${aws_vpc.nvn_vpc.id}"


  #route_table_id = "${aws_route_table.nvn_rt.id}"

  # vpc_id            = "${var.aws_vpc_id}" # vpc-e4a79a8c
  #    map_public_ip_on_launch         = true
  
  availability_zone = "${var.aws_availability_zone}"
  
  tags = { Name = "nvn_subnet01" }
 
}

resource "aws_vpc_peering_connection" "peer_connection" {
  peer_owner_id = "${var.vpc_peerowner_id}" # 780792326275
  peer_vpc_id   = "${var.aws_vpc_id}"
  vpc_id        = "${aws_vpc.nvn_vpc.id}"
  auto_accept   = true

  tags = { Name = "VPC_Peering" }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}



########################
#####################

resource "aws_internet_gateway" "nvn_ig" {
  vpc_id = "${aws_vpc.nvn_vpc.id}"
  tags = {
    Name = "nvn_IG"
  }
}


resource "aws_route_table" "nvn_rt" {
  vpc_id = "${aws_vpc.nvn_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.nvn_ig.id}"
  }

  route {
    cidr_block                = "10.0.0.0/8"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peer_connection.id}"
  }

  tags = {
    Name = "nvn_routetable"
  }
}
/*
resource "aws_route_table_association" "rt_asso" {
  subnet_id      = "${aws_subnet.nvn_subnet.id}"
  route_table_id = "${aws_route_table.nvn_rt.id}"
}
*/
resource "aws_security_group" "nvn_sg" {
  name        = "nvnsg_allow_all"
  description = "new SG to Allow all inbound traffic"
  vpc_id      = "${aws_vpc.nvn_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 1
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

###########

