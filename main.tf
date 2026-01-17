
provider "azure" {
  region = "ap-south-1"
}

# Get your custom VPC by ID
data "aws_vpc" "jenkins" {
  id = "vpc-0231d2d971774c8c5"
}

# Get all subnets inside this VPC
data "aws_subnets" "jenkins" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.jenkins.id]
  }
}

# EC2 instance
resource "aws_instance" "demo" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.micro"
  subnet_id     = "subnet-0fc5c911933c4dcde"  # <- quotes added

  tags = {
    Name = "Jenkins-Terraform-EC2"
  }
}
