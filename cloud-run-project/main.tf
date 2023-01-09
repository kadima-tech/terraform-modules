# Sets up a project for cloud run and generated a deployment user that tools can use to deploy to it

# enable the cloud run apis
resource "google_project_service" "project_cloudrun_api" {
  project = var.project
  service = "run.googleapis.com"
}

# grants the cloud run service account access to the container registry in the terraform project
resource "google_project_iam_member" "cloudrun_container_access" {
  project = var.container_registry_project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:service-${var.gcloud_project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudrun_artifact_access" {
  project = var.container_registry_project
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:service-${var.gcloud_project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}

# create a user for deploying to cloud run from github actions
resource "google_service_account" "cloudrun_deployer" {
  project      = var.project
  account_id   = "git-to-cloudrun-deployer"
  display_name = "Github actions cloudrun deployer"
}

# let the upload user create and update services
resource "google_project_iam_member" "cloudrun_deployer_deploy" {
  project = var.project
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.cloudrun_deployer.email}"
}

# let the upload user create and update services
resource "google_project_iam_member" "cloudsql_migrator" {
  project = var.project
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun_deployer.email}"
}

# Allow the user to use the cloudrun service account
resource "google_project_iam_member" "cloudrun_deployer_impersonate" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudrun_deployer.email}"
}

# Let the upload user write to the container bucket
# resource "google_storage_bucket_iam_member" "cloudrun_deployer_upload" {
#   project = var.container_registry_project
#   bucket = "eu.artifacts.${var.container_registry_project}.appspot.com"
#   role   = "roles/storage.legacyBucketWriter"
#   member = "serviceAccount:${google_service_account.cloudrun_deployer.email}"
# }

# create an account key
resource "google_service_account_key" "githubactions_cloudrun_deployer_access_key" {
  service_account_id = google_service_account.cloudrun_deployer.name
}


# Create a secret that deployers can use to upload containers and deploy to cloudrun
resource "google_secret_manager_secret" "cloudrun_deployer_secret" {
  project   = var.project
  secret_id = "cloudrun_deployer_secret"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "cloudrun_deployer_secret_version" {
  secret      = google_secret_manager_secret.cloudrun_deployer_secret.id
  secret_data = base64decode(google_service_account_key.githubactions_cloudrun_deployer_access_key.private_key)
}


