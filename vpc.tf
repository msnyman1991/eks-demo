module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//"

  name = "demo-vpc"

  cidr            = []
  private_subnets = []
  public_subnets  = []

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  flow_log_max_aggregation_interval    = 60
  create_flow_log_cloudwatch_iam_role  = true

  azs = local.azs

  enable_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  private_subnet_tags = {
    Name = "demo-vpc-private-subnet"
  }

  public_subnet_tags = {
    Name = "demo-vpc-public-subnet"
  }

  private_route_table_tags = {
    Name = "demo-vpc-private-rt"
  }

  public_route_table_tags = {
    Name = "demo-vpc-public-rt"
  }

  tags = {
    Name = "demp-vpc"
  }
}