output "name_vpc" {
    value = {
    vpc_id              = aws_vpc.my-vpc-01.id
    cidr_block          = aws_vpc.my-vpc-01.cidr_block
    default_route_table = aws_vpc.my-vpc-01.default_route_table_id
    dhcp_options_id     = aws_vpc.my-vpc-01.dhcp_options_id
    instance_tenancy    = aws_vpc.my-vpc-01.instance_tenancy
    enable_dns_support  = aws_vpc.my-vpc-01.enable_dns_support
    enable_dns_hostnames = aws_vpc.my-vpc-01.enable_dns_hostnames
    tags                = aws_vpc.my-vpc-01.tags
    }
  
}

output "load_balancer" {
    value = aws_lb.mylb[0].id
}