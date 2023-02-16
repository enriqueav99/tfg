resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "nsmongo"
  }
}
resource "kubernetes_persistent_volume_v1" "mongodb" {
  metadata {
    name = "mongopv"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    capacity     = {
      storage="10Gi"
    }
    storage_class_name = "mongopv"
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "disk-mongo"
        fs_type = "ext4"
      }
    }
  }
}

resource "kubernetes_service" "mongodb" {
  metadata {
    name      = "tfservice"
    namespace = "nsmongo"
    labels    = {
      app = "mongodb"
    }
  }
  spec {
    selector = {
      app = "mongodb"
    }
    type = "LoadBalancer"
    port {
      target_port = 27017
      port        = 27017
      protocol    = "TCP"
    }

  }
}

resource "kubernetes_stateful_set" "mongodb" {

  metadata {
    name = "mongostate"
    namespace = "nsmongo"
  }
  spec {
    service_name = "mongodbservice"
    selector {
      match_labels = {
        app ="mongodb"
      }
    }
    template {
      metadata {
        labels = {
          app ="mongodb"
        }
      }
      spec {
        container {
          name = "mongodb"
          image = "mongo"
          port {
            container_port = 27017
          }
          volume_mount {
            mount_path = "/data/db"
            name       = "mongopvc"
          }
        }
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key = "type"
                  operator = "In"
                  values = ["persistente"]
                }
              }
            }
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "mongopvc"
        namespace = "nsmongo"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "10Gi"
          }
        }
        volume_name = "mongopv"
        storage_class_name = "mongopv"
      }
    }
  }
}



