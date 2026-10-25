variable "project" {
  description = "The GCP project ID"
  default     = "oe-bc-emmanuel289"
}

variable "region" {
  description = "The region for hosting resources"
  default     = "us-east1"
}

variable "zone" {
  description = "The zone for hosting resources"
  default     = "us-east1-b"
}

variable "env" {
  description = "The target environment for deploying resources"
  default     = "dev"
}
