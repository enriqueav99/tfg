terraform {
  required_providers {
    kubernetes={
      source = "hashicorp/kubernetes"
      version="2.11.0"
    }
  }
}


provider "google" {
  project = "tfg-kubernetes-378122"
  region = "europe-north1"
  zone = "europe-north1-a"
}

data "google_container_cluster" "mongodb" {
  name = "cluster-1"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}