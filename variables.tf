


variable "access_key" {
  default = "AKIAIWVNYJMXHM7TXWHQ"
}

variable "secret_key" {
  default = "hol8Imem38D2kI4N8X+Wo2vupN5XL11JzzEQvdNk"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "aws_availability_zone" {
  default = "us-east-2a"
}


variable "aws_pubkey" {
  default = "/root/nvn/nvn_aws_sept.pub"
}


variable "aws_pvtkey" {
  default = "/root/nvn/nvn_aws_sept.pem"
}

variable "aws_vpc_id" {
  default = "vpc-e4a79a8c"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "subnet_cidr_block" {
  # default = "172.31.64.0/20"
  default = "10.0.16.0/16"
}

variable "vpc_peerowner_id" {
  default = "780792326275"
}
