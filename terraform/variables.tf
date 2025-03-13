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

variable "bigquery_table_id" {
  description = "Table ID for the BigQuery table"
  default     = "spotify_top_songs"
}

variable "bigquery_table_schema" {
  description = "Schema for the BigQuery table"
  default = <<EOF
[
  {"name": "spotify_id", "type": "STRING", "mode": "REQUIRED"},
  {"name": "name", "type": "STRING", "mode": "REQUIRED"},
  {"name": "artists", "type": "STRING", "mode": "REQUIRED"}, 
  {"name": "daily_rank", "type": "INTEGER", "mode": "REQUIRED"},
  {"name": "daily_movement", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "weekly_movement", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "country", "type": "STRING", "mode": "NULLABLE"},
  {"name": "snapshot_date", "type": "DATE", "mode": "REQUIRED"},
  {"name": "popularity", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "is_explicit", "type": "BOOLEAN", "mode": "NULLABLE"},
  {"name": "duration_ms", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "album_name", "type": "STRING", "mode": "NULLABLE"},
  {"name": "album_release_date", "type": "DATE", "mode": "NULLABLE"},
  {"name": "danceability", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "energy", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "key", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "loudness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "mode", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "speechiness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "acousticness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "instrumentalness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "liveness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "valence", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "tempo", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "time_signature", "type": "INTEGER", "mode": "NULLABLE"}
]
EOF
}