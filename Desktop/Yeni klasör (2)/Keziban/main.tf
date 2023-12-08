
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"  
  
    tags = {
      Name = "MyVPC"
    }
  }

  resource "aws_subnet" "public_subnets" {
    count      = length(var.public_subnet_cidrs)
    vpc_id     = aws_vpc.my_vpc.id
    cidr_block = element(var.public_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)
    map_public_ip_on_launch = true
    tags = {
      Name = "Public Subnet ${count.index + 1}"
    }
   }
    
   resource "aws_subnet" "private_subnets" {
    count      = length(var.private_subnet_cidrs)
    vpc_id     = aws_vpc.my_vpc.id
    cidr_block = element(var.private_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)
    tags = {
      Name = "Private Subnet ${count.index + 1}"
    }
   }

  
 resource "aws_instance" "realestate_server" {
  ami                    = "ami-0230bd60aa48260c6"
  instance_type          = "t3a.medium"
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.realestate_sg.id]
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subnets[0].id

  tags = {
    Name = "realestate_server"
  }

}
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.my_vpc.id
    
    tags = {
      Name = "Project VPC IG"
    }
   }
   
   resource "aws_route_table" "second_rt" {
    vpc_id = aws_vpc.my_vpc.id
    
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }
    
    tags = {
      Name = "2nd Route Table"
    }
   }

  resource "aws_route_table_association" "a" {
  count=3
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.second_rt.id
}
resource "aws_security_group" "realestate_sg" {
  vpc_id     = aws_vpc.my_vpc.id
  name = "realestate_sg"
  tags = {
    Name = "realestate_sg"
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8092
    protocol    = "tcp"
    to_port     = 8092
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
} 
