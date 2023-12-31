resource "kubernetes_ingress_v1" "ingress" {
  depends_on = [helm_release.loadbalancer_controller, helm_release.external_dns]
  wait_for_load_balancer = true
  metadata {
    name = "ingress-externaldns"
    annotations = {
      # Load Balancer Name
      "alb.ingress.kubernetes.io/load-balancer-name" = "ingress-externaldns"
      # Ingress Core Settings
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      # Health Check Settings
      "alb.ingress.kubernetes.io/healthcheck-protocol" =  "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-port" = "traffic-port"
      #Important Note:  Need to add health check path annotations in service level if we are planning to use multiple targets in a load balancer    
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = 30
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds" = 15
      "alb.ingress.kubernetes.io/success-codes" = 200
      "alb.ingress.kubernetes.io/healthy-threshold-count" = 4
      "alb.ingress.kubernetes.io/unhealthy-threshold-count" = 4
      ## SSL Settings
      # Option-1: Using Terraform jsonencode Function
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([{"HTTPS" = 443}, {"HTTP" = 80}])
      # Option-2: Using Terraform File Function      
      #"alb.ingress.kubernetes.io/listen-ports" = file("${path.module}/listen-ports/listen-ports.json")
      "alb.ingress.kubernetes.io/certificate-arn" =  "${var.ssl_certificate_arn}"
      #"alb.ingress.kubernetes.io/ssl-policy" = "ELBSecurityPolicy-TLS-1-1-2017-01" #Optional (Picks default if not used)    
      # SSL Redirect Setting
      "alb.ingress.kubernetes.io/ssl-redirect" = 443
      # External DNS - For creating a Record Set in Route53
      #"external-dns.alpha.kubernetes.io/hostname" = "movie.greeta.net, api.greeta.net, keycloak.greeta.net, grafana.greeta.net, kafka.greeta.net"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }  
  }

  spec {
    ingress_class_name = "my-aws-ingress-class"

    default_backend {
     
      service {
        name = "gateway"
        port {
          number = 8080
        }
      }
    }     

    rule {
      host = "api.greeta.net"
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
      host = "grafana.greeta.net"
      http {

        path {
          backend {
            service {
              name = "loki-stack-grafana"
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
      host = "movie.greeta.net"
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
