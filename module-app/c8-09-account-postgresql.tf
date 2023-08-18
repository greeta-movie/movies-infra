 resource "kubernetes_config_map_v1" "account_postgres_config_map" {
   metadata {
     name = "account-postgres-dbcreation-script"
   }
   data = {
    "account-db.sql" = "${file("${path.module}/account-db.sql")}"
   }
 } 

resource "kubernetes_deployment_v1" "account_postgres" {
  metadata {
    name = "account-postgres"

    labels = {
      db = "account-postgres"
    }
  }

  spec {
    selector {
      match_labels = {
        db = "account-postgres"
      }
    }

    template {
      metadata {
        labels = {
          db = "account-postgres"
        }
      }

      spec {
        volume {
          name = "account-postgres-dbcreation-script"
          config_map {
            name = kubernetes_config_map_v1.account_postgres_config_map.metadata.0.name 
          }
        }          
        container {
          name  = "account-postgres"
          image = "postgres:latest"

          env {
            name  = "POSTGRES_PASSWORD"
            value = "techbankrootpsw"
          }
          volume_mount {
            name = "account-postgres-dbcreation-script"
            mount_path = "/docker-entrypoint-initdb.d"
          }           

        }
      }
    }
  }
}

resource "kubernetes_service" "account_postgres" {
  metadata {
    name = "account-postgres"

    labels = {
      db = "account-postgres"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      db = "account-postgres"
    }

    port {
      protocol    = "TCP"
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "account_postgres_hpa" {
  metadata {
    name = "account-postgres-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.account_postgres.metadata[0].name 
    }
    target_cpu_utilization_percentage = 80
  }
}