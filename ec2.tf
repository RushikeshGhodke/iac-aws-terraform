# key pair
resource "aws_key_pair" "iac-key" {
  key_name   = "terra-key"
  public_key = file("terra-key.pub")
}

# vpc
resource "aws_default_vpc" "default_vpc" {

}

resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
  description = "security grp manage by terraform"
  vpc_id      = aws_default_vpc.default_vpc.id

  tags = {
    name = "terraform-key"
  }
}

# ingress rules
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "ingress for SSH"
  security_group_id = aws_security_group.terraform_sg.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "http"
  security_group_id = aws_security_group.terraform_sg.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "https"
  security_group_id = aws_security_group.terraform_sg.id
}

resource "aws_security_group_rule" "node_app" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "node-app"
  security_group_id = aws_security_group.terraform_sg.id
}

# egress rule
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "all access open"
  security_group_id = aws_security_group.terraform_sg.id
}

resource "aws_instance" "terraform_ec2" {
    
  ami             = "ami-0bc691261a82b32bc"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.iac-key.key_name
  security_groups = [aws_security_group.terraform_sg.name]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "ec2-by-terraform"
  }
}