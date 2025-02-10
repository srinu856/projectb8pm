# Configure the Google Cloud provider
provider "google" {
  # credentials = file(var.google_credentials_file)
  project     = var.google_project_id
  region      = var.google_region
}

# Create a VM instance
resource "google_compute_instance" "mysql_vm" {
  name         = var.vm_name
  machine_type = var.vm_machine_type
  zone         = var.vm_zone
  tags         = var.vm_tags

  boot_disk {
    auto_delete = true
    device_name = var.boot_disk_device_name

    initialize_params {
      image = var.vm_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }

    mode = "READ_WRITE"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = var.vm_startup_script
}

# Create a firewall rule to allow all traffic
resource "google_compute_firewall" "allow_all" {
  name    = var.firewall_name
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.firewall_target_tags
}
