# Resource: Kubernetes Storage Class
resource "kubernetes_storage_class_v1" "efs_keycloak_sc" {  
  metadata {
    name = "efs-keycloak-sc"
  }
  storage_provisioner = "efs.csi.aws.com"
}

resource "kubernetes_storage_class_v1" "efs_mongodb_sc" {  
  metadata {
    name = "efs-mongodb-sc"
  }
  storage_provisioner = "efs.csi.aws.com"
}