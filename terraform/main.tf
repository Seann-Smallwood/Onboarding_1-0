terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.6.0"

  # GCS backend for CI/CD (configured via backend config file or environment)
  # For local development, this will use local state
}

provider "google" {
  # credentials will be provided via GOOGLE_APPLICATION_CREDENTIALS env var in CI/CD
  # or via file() function locally: credentials = file("key.json") 
  project = var.project_id
  region  = var.region
}

# Artifact Registry repository
resource "google_artifact_registry_repository" "api_repo" {
  location       = var.region
  repository_id  = var.repo_name
  description    = "Repository for API Docker images"
  format         = "DOCKER"
}

# Cloud Run service
resource "google_cloud_run_service" "api_service" {
  name     = var.service_name
  location = var.region

  template {
    spec {
        containers {
            image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.api_repo.repository_id}/${var.image_name}:latest"
            ports {
                container_port = 8080
            }
        }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Allow public access to Cloud Run
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.api_service.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
