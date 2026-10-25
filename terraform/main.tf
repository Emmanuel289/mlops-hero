terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }

  }
}


provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone

}

resource "google_service_account" "mlops_sa" {
  account_id   = "mlops-sa"
  display_name = "Custom service account for mlops VM instance"
}

# Custom Mode VPC Network and Subnet
data "google_compute_network" "network" {
  name = var.project
}

data "google_compute_subnetwork" "subnet" {
  name = var.project
}

## E2 Standard machine with 4 vCPUs and 16GB memory
resource "google_compute_instance" "mlops_vm" {
  name         = "mlops-vm"
  machine_type = "e2-standard-4"
  zone         = "us-east1-b"

  tags = ["mlops"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-pro-cloud/ubuntu-minimal-pro-2404-lts-amd64"

      labels = {
        environment = var.env
      }
    }
  }

  network_interface {
    network    = data.google_compute_network.network.id
    subnetwork = data.google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral public IP
    }
  }



  metadata_startup_script = file("scripts/install_docker.sh")

  metadata = {
    ssh-keys = "okech:${file("~/.ssh/mlops_vm_key.pub")}"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted
    # via IAM Roles.
    email  = google_service_account.mlops_sa.email
    scopes = ["cloud-platform"]
  }
}
