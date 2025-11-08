locals {
  az_names = slice(data.aws_availability_zones.azs.names,0,2)

}

locals {
  name_prefix = "Web-sg-"
}