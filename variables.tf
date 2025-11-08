variable "aws_cidr" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "public_subnet_cidrs" {
    type = list 
    default = ["10.0.1.0/24", "10.0.2.0/24"] 
}

variable "ingress_rules" {
  description = "A list of ingress rule objects."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "bucket-name" {
    type = string
    default = "kasa-masa-posa-kubusa"
  
}

variable "instance_type" {
    type = string
    default = "t2.micro"
  
}

variable "user_data" {
    type = list (string)
    default = ["userdata.sh", "userdata1.sh"]
  
}