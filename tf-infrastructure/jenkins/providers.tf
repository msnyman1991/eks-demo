# Used by Terraform resource <resource "helm_release" "jenkins"> to get cluster details for installing helm chart
provider "helm" {
  kubernetes {
    host                   = module.eks-cluster-jenkins.cluster_endpoint
    cluster_ca_certificate = module.eks-cluster-jenkins.cluster_certificate_authority_data
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks-cluster-jenkins.cluster_name
      ]
    }
  }
}

# Used by Terraform resource <resource "kubernetes_namespace" "jenkins"> to get cluster details for namespace creation
provider "kubernetes" {
  host                   = module.eks-cluster-jenkins.cluster_endpoint
  cluster_ca_certificate = module.eks-cluster-jenkins.cluster_certificate_authority_data
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks-cluster-jenkins.cluster_name
    ]
  }
}
