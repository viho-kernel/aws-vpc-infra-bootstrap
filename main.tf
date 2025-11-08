# Create a new VPC using the CIDR block provided in the variable 'aws_cidr'
resource "aws_vpc" "my-vpc-01" {
  cidr_block = var.aws_cidr
  tags = {
    Name = "Project-VPC"
  }
}

# Attach an Internet Gateway to the VPC to enable internet access for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc-01.id

  tags = {
    Name = "Internet-Gateway"  # Tag for easy identification in the AWS console
  }
}

# Create multiple public subnets based on the list of CIDRs provided in 'public_subnet_cidrs'
resource "aws_subnet" "pub-sub" {
  count = length(var.public_subnet_cidrs)  # Dynamically create one subnet per CIDR

  vpc_id     = aws_vpc.my-vpc-01.id  # Associate each subnet with the VPC
  cidr_block = element(var.public_subnet_cidrs[*], count.index)  # Assign CIDR block from the list
  availability_zone = local.az_names[count.index]  # Distribute subnets across availability zones
  map_public_ip_on_launch = true  # Automatically assign public IPs to instances launched in this subnet

  tags = {
    Name = "Public-subnet-${count.index + 1}"  # Tag each subnet with a unique name
  }
}

# Create a route table for public subnets
resource "aws_route_table" "My-RT" {
    vpc_id = aws_vpc.my-vpc-01.id

    tags = {
      Name = "PublicRoutetable"
    }

  
}

# Add a default route to the internet via the Internet Gateway
resource "aws_route" "public_internet_route" {
    route_table_id = aws_route_table.My-RT.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  
}

# Associate each public subnet with the public route table
resource "aws_route_table_association" "pub-ass" {
    count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.pub-sub[count.index].id
  route_table_id = aws_route_table.My-RT.id
}

# Create a security group with dynamic ingress rules and open egress
resource "aws_security_group" "mySG" {

    dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  } 

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    tags = {
        Name = "Security-Group-01"
    }

    vpc_id = aws_vpc.my-vpc-01.id
  
}

# Create an S3 bucket using the provided variable name
resource "aws_s3_bucket" "kosa" {
  bucket = var.bucket-name

}

# Disable all public access restrictions on the S3 bucket
resource "aws_s3_bucket_public_access_block" "example1" {
  bucket = aws_s3_bucket.kosa.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Launch EC2 instances with user data and security group

resource "aws_instance" "instances" {
    count = 2
    ami           = "ami-0ecb62995f68bb549" # Replace with a valid AMI ID for your region
    instance_type = var.instance_type
    key_name      = "DevOPS_Project_Key" # Replace with your key pair name
    vpc_security_group_ids = [aws_security_group.mySG.id]
    tags = {
        Name = "MyTerraformInstance-${count.index+1}"
        Environment = "Dev"
      }
    user_data_base64 = base64encode(file(var.user_data[count.index]))


}

# Create an Application Load Balancer across public subnets
resource "aws_lb" "mylb" {
    count = length(aws_subnet.pub-sub)
    name = "mylb"
    internal = false 
    load_balancer_type = "application"
    security_groups = [aws_security_group.mySG.id]
    subnets = [aws_subnet.pub-sub[count.index].id]


    tags = {
      Environment = "Dev"
    }


  
}

# Create a target group for the load balancer
resource "aws_lb_target_group" "tgtest" {
  name     = "tgtest-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc-01.id
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# Attach EC2 instances to the target group
resource "aws_lb_target_group_attachment" "attachment" {
    count = length(aws_instance.instances)
  target_group_arn = aws_lb_target_group.tgtest.arn
  target_id        = aws_instance.instances[count.index].id
  port             = 80
}

# Create a listener to forward HTTP traffic to the target group

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.mylb[0].arn
    port = 80
    protocol = "HTTP"

    default_action {
      target_group_arn = aws_lb_target_group.tgtest.arn
      type = "forward"
    }
  
}