variable "credentials_file" {
  description = "Path to the GCP Service Account Key JSON file"
  default     = "../keys/project.json"
}

variable "project_id" {
  description = "Google Cloud Project ID"
  default     = "spotify-sandbox-453505"
}

variable "region" {
  description = "GCP Region for resource deployment"
  default     = "europe-west1" 
}

variable "location" {
  description = "Location for BigQuery dataset (use 'EU' for multi-region)"
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "Name of the BigQuery dataset for storing processed data"
  default     = "spotify_radu_dataset" 
}

variable "gcs_bucket_name" {
  description = "Name of the GCS bucket for raw data storage"
  default     = "spotify_radu_bucket"
}

variable "gcs_storage_class" {
  description = "Storage class for GCS bucket (STANDARD, NEARLINE, COLDLINE, ARCHIVE)"
  default     = "STANDARD"
}