provider "google" {
  project = "pradeep-sandbox"
  region  = "us-central1"
  credentials = jsondecode(var.google_credentials)
}
variable "google_credentials" {}

# 🚨 Intentionally insecure storage bucket (public access enabled) 🚨
resource "google_storage_bucket" "public_bucket" {
  name          = "my-insecure-bucket"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = false  # ❌ Checkov will flag this as insecure!

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }

  public_access_prevention = "enforced"
}

# Create a VM instance
resource "google_compute_instance" "vm_instance" {
  name         = "test-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}  # Enables external IP (Checkov may warn about public access)
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  tags = ["web"]
}

# 🚨 Firewall Rule - Open to all IPs (Intentional Security Risk) 🚨
resource "google_compute_firewall" "allow_all" {
  name    = "allow-all"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]  # Allows SSH and Web Traffic
  }

  source_ranges = ["0.0.0.0/0"]  # ❌ This allows unrestricted access (Checkov will flag this!)
  target_tags   = ["web"]
}
