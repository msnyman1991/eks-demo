module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//"

  name = "demo-vpc"

  cidr            = "10.70.0.0/16"
  private_subnets = ["10.70.1.0/24", "10.70.2.0/24", "10.70.3.0/24"]
  public_subnets  = ["10.70.81.0/24", "10.70.82.0/24", "10.70.83.0/24"]

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  flow_log_max_aggregation_interval    = 60
  create_flow_log_cloudwatch_iam_role  = true

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  enable_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name_jenkins}" = "shared"
    "kubernetes.io/role/elb"                              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name_jenkins}" = "shared"
    "kubernetes.io/role/internal-elb"                     = 1
  }

  private_route_table_tags = {
    Name = "demo-vpc-private-rt"
  }

  public_route_table_tags = {
    Name = "demo-vpc-public-rt"
  }

  tags = {
    Name = "demo-vpc"
  }
}
