resource "google_service_account" "service-account" {
  project      = var.project
  account_id   = replace(var.host, ".", "-")
  display_name = "${var.host} Deployer"
}

resource "google_service_account_key" "deployer-key" {
  service_account_id = google_service_account.service-account.name
}

resource "google_secret_manager_secret" "deployer-key" {
  project   = var.project
  secret_id = "${replace(var.host, ".", "-")}-service-account-pkey"

  labels = {
    bucket_host = replace(var.host, ".", "-")
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret      = google_secret_manager_secret.deployer-key.id
  secret_data = base64decode(google_service_account_key.deployer-key.private_key)
}

resource "google_storage_bucket_iam_member" "deployer-policy" {
  bucket     = google_storage_bucket.static-site.name
  role       = "roles/storage.objectAdmin"
  member     = "serviceAccount:${google_service_account.service-account.email}"
  depends_on = [google_storage_bucket.static-site]
}

resource "google_storage_bucket_iam_member" "public-access" {
  bucket     = google_storage_bucket.static-site.name
  role       = "roles/storage.objectViewer"
  member     = "allUsers"
  depends_on = [google_storage_bucket.static-site]
}

resource "google_compute_backend_bucket" "backend" {
  project     = var.project
  name        = "${replace(var.host, ".", "-")}-backend"
  description = "Back-end for docs bucket"
  bucket_name = google_storage_bucket.static-site.name
  enable_cdn  = false
}

resource "google_storage_bucket" "static-site" {
  project       = var.project
  name          = var.host
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  cors {
    origin          = ["http://${var.host}","https://${var.host}"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

