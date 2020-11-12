
provider aws {
  region     = "us-east-1"
}

resource aws_vpc "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource aws_subnet "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.servername}subnet"
  }
}