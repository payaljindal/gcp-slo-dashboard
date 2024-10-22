terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Or the latest compatible version
    }
  }
}


provider "google" {
  project = "ep-upskilling-appdev"
  region  = "us-central1"
}
