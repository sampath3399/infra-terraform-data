provider "google" {
  project = "migrationproject62718"
  region  = "us-central1"
}

# GCS Buckets for dev and prod
resource "google_storage_bucket" "batch_pipeline_gcs_dev" {
  name     = "batch-pipeline-gcs-bucket-dev"
  location = "US-CENTRAL1"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "batch_pipeline_gcs_prod" {
  name     = "batch-pipeline-gcs-bucket-prod"
  location = "US-CENTRAL1"
  versioning {
    enabled = true
  }
}

# BigQuery Datasets
resource "google_bigquery_dataset" "walmart_products_dataset" {
  dataset_id = "walmart-products-dev"
  location   = "US"
}

resource "google_bigquery_dataset" "walmart_customers_dataset" {
  dataset_id = "walmart-customers-dev"
  location   = "US"
}

# BigQuery Tables (schema example for Walmart products and customers)
resource "google_bigquery_table" "walmart_products_table" {
  dataset_id = google_bigquery_dataset.walmart_products_dataset.dataset_id
  table_id   = "walmart-products"
  schema     = jsonencode([
    {
      name = "product_id"
      type = "STRING"
    },
    {
      name = "product_name"
      type = "STRING"
    },
    {
      name = "price"
      type = "FLOAT"
    }
  ])
}

resource "google_bigquery_table" "walmart_customers_table" {
  dataset_id = google_bigquery_dataset.walmart_customers_dataset.dataset_id
  table_id   = "walmart-customers"
  schema     = jsonencode([
    {
      name = "customer_id"
      type = "STRING"
    },
    {
      name = "customer_name"
      type = "STRING"
    },
    {
      name = "email"
      type = "STRING"
    }
  ])
}

# Backend Configuration for Terraform state
terraform {
  backend "gcs" {
    bucket = "migrationproject62718-terraform-state"
    prefix = "terraform/state"
  }
}
