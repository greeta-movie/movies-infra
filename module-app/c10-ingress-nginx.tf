resource "kubernetes_ingress_v1" "ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "simple-fanout-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "kubernetes.io/ingress.class" =  "nginx"   
    }  
  }

  spec {
    ingress_class_name = "nginx"

    default_backend {
     
      service {
        name = "gateway"
        port {
          number = 8080
        }
      }
    }     

    rule {
      host = "movie.greeta.net"
      http {

        path {
          backend {
            service {
              name = "gateway"
              port {
                number = 8080
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    }

    rule {
      host = "keycloak.greeta.net"
      http {

        path {
          backend {
            service {
              name = "keycloak-server"
              port {
                number = 8080
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    }    

    rule {
      host = "kafka.greeta.net"
      http {

        path {
          backend {
            service {
              name = "kafka-ui"
              port {
                number = 8080
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    }

    rule {
      host = "grafana.greeta.net"
      http {

        path {
          backend {
            service {
              name = "loki-stack-grafana-bridge"
              port {
                number = 80
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    } 

    rule {
      host = "ui.greeta.net"
      http {

        path {
          backend {
            service {
              name = "movie-ui"
              port {
                number = 4200
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    }                  
    
  }
}
