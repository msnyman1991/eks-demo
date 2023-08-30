module "ecr" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecr.git//?ref=v1.6.0"

  repository_name = "ecr-demo"

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  create_lifecycle_policy           = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_force_delete = true

  tags = {
    Name       = ""
    Example    = ""
  }
}
