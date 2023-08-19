# Resource: Persistent Volume Claim
resource "kubernetes_persistent_volume_claim_v1" "efs_keycloak_pvc" {
  metadata {
    name = "efs-keycloak-claim"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = kubernetes_storage_class_v1.efs_sc.metadata[0].name 
    resources {
      requests = {
        storage = "5Gi" 
      }
    }
  }
}
 
# Storage Size (storage = "5Gi")
## You can specify any size for the persistent volume in the storage field. 
## Kubernetes requires this field, but because Amazon EFS is an 
## elastic file system, it does not enforce any file system capacity. 


resource "kubernetes_persistent_volume_claim_v1" "efs_mongodb_pvc" {
  metadata {
    name = "efs-mongodb-claim"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = kubernetes_storage_class_v1.efs_sc.metadata[0].name 
    resources {
      requests = {
        storage = "5Gi" 
      }
    }
  }
}
  