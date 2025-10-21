variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Deployment region"
  type        = string
  default     = "us-central1"
}

variable "repo_name" {
  description = "Artifact Registry repository name"
  type        = string
  default     = "api-repo"
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
  default     = "my-api-service"
}

variable "image_name" {
  description = "Docker image name"
  type        = string
  default     = "my-api"
}
