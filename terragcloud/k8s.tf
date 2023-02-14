resource "kubernetes_namespace" "saludo" {
  metadata {
    name = "nsaludo"
  }
}
resource "kubernetes_deployment" "saludo" {
  metadata {
    name = "tfdeployment"
    labels = {
      app = "saludo"
    }
    namespace = "nsaludo"
  }

  spec {
    replicas = "3"
    selector {
      match_labels = {
        app="saludo"
      }
    }
    template {
      metadata {
        labels = {
          app="saludo"
        }
      }
      spec {
        container {
          image = "enriqueav99/saludoja:latest"
          name = "saludo"
        }
      }
    }
  }
}

resource "kubernetes_service" "saludo" {
  metadata {
    name      = "tfservice"
    namespace = "nsaludo"
    labels    = {
      app = "saludo"
    }
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "saludo"
    }

    port {
      target_port = 8080
      port        = 8080
      protocol    = "TCP"
    }

  }
}

