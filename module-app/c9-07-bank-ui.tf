resource "kubernetes_deployment_v1" "bank_ui_deployment" {
  depends_on = [kubernetes_deployment_v1.bank_deployment]
  metadata {
    name = "bank-ui"
    labels = {
      app = "bank-ui"
    }
  }
 
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "bank-ui"
      }
    }
    template {
      metadata {
        labels = {
          app = "bank-ui"
        }
      }
      spec {
        container {
          image = "ghcr.io/greeta-bank/bank-ui"
          name  = "bank-ui"
          image_pull_policy = "Always"
          port {
            container_port = 4200
          }                                                                                          
        }
      }
    }
  }
}

# Resource: Keycloak Server Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v1" "bank_ui_hpa" {
  metadata {
    name = "bank-ui-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.bank_ui_deployment.metadata[0].name
    }
    target_cpu_utilization_percentage = 80
  }
}

resource "kubernetes_service_v1" "bank_ui_service" {
  metadata {
    name = "bank-ui"
  }
  spec {
    selector = {
      app = "bank-ui"
    }
    port {
      port = 4200
    }
  }
}
