resource "aws_vpc" "blue" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "VPC-Blue"
  }
}


resource "aws_subnet" "sn_blue" {
  count = length(var.subnet_cidrs)

  cidr_block        = var.subnet_cidrs[count.index]
  vpc_id            = aws_vpc.blue.id
  availability_zone = var.availability_zones[count.index]
}

output "subnet_ids" {
  value = aws_subnet.sn_blue.*.id
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.blue.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.blue.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "public" {
  count = length(aws_subnet.sn_blue)
  subnet_id = aws_subnet.sn_blue[count.index].id
  route_table_id = aws_route_table.public.id
}

