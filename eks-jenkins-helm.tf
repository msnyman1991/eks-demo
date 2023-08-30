resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "4.2.17"
  namespace  = "jenkins"
  timeout    = 600

  values = [
    file("../jenkins-config/values.yaml"),
  ]

  set {
    name  = "controller.initContainers[0].name"
    value = "docker-install"
  }

  set {
    name  = "controller.initContainers[0].image"
    value = "docker:20.10"  # Use the desired Docker version
  }

  set {
    name  = "controller.initContainers[0].command"
    value = ["sh", "-c", "curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"]
  }

  set {
    name  = "controller.containers[0].volumeMounts"
    value = [
      {
        name      = "docker-socket"
        mountPath = "/var/run/docker.sock"
      }
    ]
  }

  set {
    name  = "controller.volumes[0].name"
    value = "docker-socket"
  }

  set {
    name  = "controller.volumes[0].hostPath.path"
    value = "/var/run/docker.sock"
  }

  depends_on = [
    kubernetes_namespace.jenkins,
  ]
}


resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"

    labels = {
      name        = "jenkins"
      description = "jenkins"
    }
  }
}