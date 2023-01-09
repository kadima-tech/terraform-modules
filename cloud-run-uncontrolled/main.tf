
resource "google_cloud_run_service" "default" {
  provider = google-beta

  name                       = var.name
  location                   = var.location
  autogenerate_revision_name = true
  project                    = local.project_id

  metadata {
    namespace = local.project_id
    labels    = var.labels
    annotations = merge(
      {
        "run.googleapis.com/ingress"    = var.ingress
        "client.knative.dev/user-image" = var.image
      },
      length(local.secrets_to_aliases) < 1 ? {} : {
        "run.googleapis.com/secrets" = join(",", [for secret, alias in local.secrets_to_aliases : "${alias}:${secret}"])
      }
    )
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["run.googleapis.com/client-name"],
      metadata[0].annotations["client.knative.dev/user-image"],
      template[0].spec[0].containers[0].image, # will be updated by cloud run
      metadata[0].annotations["run.googleapis.com/client-version"],
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
      template[0].metadata[0].annotations["run.googleapis.com/sandbox"],
      metadata[0].annotations["serving.knative.dev/creator"],
      metadata[0].annotations["serving.knative.dev/lastModifier"],
      metadata[0].annotations["run.googleapis.com/ingress-status"],
      metadata[0].labels["cloud.googleapis.com/location"],
      template[0].spec[0].containers[0].ports[0].name
    ]
  }

  template {
    spec {
      container_concurrency = var.concurrency
      timeout_seconds       = var.timeout
      service_account_name  = var.service_account_email == null ? google_service_account.no_permissions.email : var.service_account_email

      containers {
        image   = var.image
        command = var.entrypoint
        args    = var.args

        ports {
          container_port = var.port
        }

        resources {
          limits = {
            cpu    = "${var.cpus * 1000}m"
            memory = "${var.memory}Mi"
          }
        }

        # Populate straight environment variables.
        dynamic "env" {
          for_each = [for e in local.env : e if e.value != null]

          content {
            name  = env.value.key
            value = env.value.value
          }
        }

        # Populate environment variables from secrets.
        dynamic "env" {
          for_each = [for e in local.env : e if e.secret.name != null]

          content {
            name = env.value.key
            value_from {
              secret_key_ref {
                name = coalesce(env.value.secret.alias, env.value.secret.name)
                key  = env.value.secret.version
              }
            }
          }
        }

        dynamic "volume_mounts" {
          for_each = local.volumes

          content {
            name       = volume_mounts.value.name
            mount_path = volume_mounts.value.path
          }
        }
      }

      dynamic "volumes" {
        for_each = local.volumes

        content {
          name = volumes.value.name

          secret {
            secret_name = coalesce(volumes.value.secret.alias, volumes.value.secret.name)

            dynamic "items" {
              for_each = volumes.value.items

              content {
                key  = items.value.version
                path = items.value.filename
              }
            }
          }
        }
      }
    }

    metadata {
      labels = var.labels
      annotations = merge(
        {
          "run.googleapis.com/launch-stage"       = local.launch_stage
          "run.googleapis.com/cloudsql-instances" = join(",", var.cloudsql_connections)
          "autoscaling.knative.dev/maxScale"      = var.max_instances
          "autoscaling.knative.dev/minScale"      = var.min_instances
        },
        var.cpu_throttling == null ? {} : {
          "run.googleapis.com/cpu-throttling" = var.cpu_throttling
        },
        var.vpc_connector_name == null ? {} : {
          "run.googleapis.com/vpc-access-connector" = var.vpc_connector_name
          "run.googleapis.com/vpc-access-egress"    = local.vpc_access.egress
        },
        length(local.secrets_to_aliases) < 1 ? {} : {
          "run.googleapis.com/secrets" = join(",", [for secret, alias in local.secrets_to_aliases : "${alias}:${secret}"])
        },
      )
    }
  }

  traffic {
    percent         = 100
    latest_revision = var.revision == null
    revision_name   = var.revision != null ? "${var.name}-${var.revision}" : null
  }
}


resource "google_cloud_run_service_iam_member" "public_access" {
  count    = var.allow_unauthenticed_access ? 1 : 0
  service  = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_domain_mapping" "domains" {
  for_each = var.map_domains

  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  name     = each.value

  metadata {
    namespace = google_cloud_run_service.default.project
    annotations = {
      "run.googleapis.com/launch-stage" = local.launch_stage
    }
  }

  spec {
    route_name = google_cloud_run_service.default.name
  }

  lifecycle {
    ignore_changes = [metadata[0]]
  }
}

# create serverless network endpoint group so we can link it to a load balancer backend
resource "google_compute_region_network_endpoint_group" "serverless-neg" {
  count                 = var.loadbalancer_backend_create ? 1 : 0
  name                  = var.name
  region                = var.location
  project               = google_cloud_run_service.default.project
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = google_cloud_run_service.default.name
  }
}

# create a load balancer backend for the service
resource "google_compute_backend_service" "load-balancer-backend" {
  count           = var.loadbalancer_backend_create ? 1 : 0
  project         = google_cloud_run_service.default.project
  name            = "${var.name}-backend"
  description     = "${var.name} backend service"
  protocol        = "HTTP"
  port_name       = "http"
  timeout_sec     = 30
  enable_cdn      = false
  security_policy = var.security_policy

  backend {
    capacity_scaler = 0.3
    group           = google_compute_region_network_endpoint_group.serverless-neg[count.index].id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_service_account" "no_permissions" {
  project      = local.project_id
  account_id   = "${var.name}-empty"
  display_name = "${var.name} service account with no permissions"
}