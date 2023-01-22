

resource "google_compute_subnetwork" "internal-connector-subnet" {
  project  = var.project
  provider = google-beta

  name                     = "connector-subnet"
  ip_cidr_range            = "10.10.0.0/28"
  region                   = var.region
  network                  = var.private_network
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.1
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_vpc_access_connector" "connector" {
  project  = var.project
  provider = google-beta

  name = "connector-vpc-access"
  subnet {
    name = google_compute_subnetwork.internal-connector-subnet.name
  }

  lifecycle {
    ignore_changes = [
      network
    ]
  }
}
