# resource "helm_release" "eks_app" {
#   name       = ""
#   repository = ""
#   chart      = ""
#   version    = ""
#   namespace  = ""
#   timeout    = ""
#   values = [
#     file(""),
#   ]

#   depends_on = [
#     kubernetes_namespace.eks_app,
#   ]
# }

# resource "kubernetes_namespace" "eks_app" {
#   metadata {
#     name = "eks_app"

#     labels = {
#       name        = "eks_app"
#       description = "eks_app"
#     }
#   }
# }