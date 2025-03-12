terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

resource "google_storage_bucket" "spotify_radu_bucket" {
  name          = var.gcs_bucket_name
  location      = var.region
  force_destroy = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 60 # Delete files older than 60 days
    }
  }
}

resource "google_bigquery_dataset" "spotify_radu_dataset" {
  dataset_id  = var.bq_dataset_name
  project     = var.project_id
  location   = var.location
}