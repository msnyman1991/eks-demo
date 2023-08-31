resource "aws_security_group" "jenkins_node_group_one" {
  name_prefix = "jenkins_node_group_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "jenkins_node_group_two" {
  name_prefix = "jenkins_node_group_two"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }
}

module "eks-cluster-jenkins" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git//?ref=v19.16.0"

  cluster_name    = local.cluster_name_jenkins
  cluster_version = "1.27"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    attach_cluster_primary_security_group = true

    create_security_group = false

  }

  eks_managed_node_groups = {
    one = {
      name = "jenkins-node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      pre_bootstrap_user_data = <<-EOT
      echo 'Hello There'
      EOT

      vpc_security_group_ids = [
        aws_security_group.jenkins_node_group_one.id
      ]
    }

    two = {
      name = "jenkins-node-group-2"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      pre_bootstrap_user_data = <<-EOT
      echo 'Hello There'
      EOT

      vpc_security_group_ids = [
        aws_security_group.jenkins_node_group_two.id
      ]
    }
  }
  node_security_group_tags = {
    "kubernetes.io/cluster/eks-demo-jenkins" = null
  }
}

data "aws_iam_policy" "cluster_jenkins_ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "cluster-jenkins-irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks-cluster-jenkins.cluster_name}"
  provider_url                  = module.eks-cluster-jenkins.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.cluster_jenkins_ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "cluster-jenkins-ebs-csi" {
  cluster_name             = module.eks-cluster-jenkins.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = module.cluster-jenkins-irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}
