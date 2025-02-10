data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"
  name    = "${var.project_name}-vpc"
  cidr    = var.vpc_cidr 
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets  = var.private_subnets 
  public_subnets   = var.public_subnets 
  nat_gateway_tags = {
    "Name" = "${var.project_name}-nat-gateway"
  }
  public_route_table_tags = {
    "Name" = "${var.project_name}-public-route-table"
  }
  private_route_table_tags = {
    "Name" = "${var.project_name}-private-route-table"
  }
}
