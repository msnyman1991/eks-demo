# Retrieves cluster details from Terraform resource <provider "helm">
resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "4.2.17"
  namespace  = "jenkins"
  timeout    = 600

  values = [
    file("./values.yaml"),
  ]

  depends_on = [
    kubernetes_namespace.jenkins,
  ]
}

# Retrieves cluster details from Terraform resource <provider "kubernetes">
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"

    labels = {
      name        = "jenkins"
      description = "jenkins"
    }
  }
}