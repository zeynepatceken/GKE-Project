terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project     = "sixth-now-459322-e7"
  region      = "europe-west1"
  credentials = "C:/Users/Dell/Downloads/sixth-now-459322-e7-d0d602fe4eff.json"
}

resource "google_container_cluster" "k8s_cluster" {
  name                     = "my-cluster"
  location                 = "europe-west1"
  remove_default_node_pool = true
  initial_node_count       = 1
  logging_service          = "none"
  monitoring_service       = "none"
}

resource "google_container_node_pool" "main_pool" {
  name               = "main-pool"
  cluster            = google_container_cluster.k8s_cluster.name
  location           = "europe-west1"
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_type    = "pd-standard"
    disk_size_gb = 30
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

}

resource "google_container_node_pool" "application_pool" {
  name               = "application-pool"
  cluster            = google_container_cluster.k8s_cluster.name
  location           = "europe-west1"
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-medium"
    disk_type    = "pd-standard"
    disk_size_gb = 30
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
