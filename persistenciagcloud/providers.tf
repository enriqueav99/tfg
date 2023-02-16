terraform {
  required_providers {
    kubernetes={
      source = "hashicorp/kubernetes"
      version="2.11.0"
    }
  }
}
resource "google_compute_disk" "mongodb" {
  name = "disk-mongo"
  source_disk="disk-mongo"
  zone = "europe-north1-a"
  size = 10
}

provider "google" {
  project = "tfgsubernetes"
  region = "europe-north1"
  zone = "europe-north1-a"
}

data "google_container_cluster" "mongodb" {
  name = "cluster-1"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}