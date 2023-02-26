
resource "google_sql_database_instance" "master" {
  project             = var.project
  database_version    = var.database_version
  region              = var.region
  deletion_protection = var.deletion_protection

  # TODO: Depends On
  # depends_on = [
  #   "google_service_networking_connection.private_vpc_connection"
  # ]

  settings {
    tier = var.sql_machine_type

    disk_size = var.sql_disk_size

    ip_configuration {
      private_network = var.private_network
    }

    backup_configuration {
      enabled = true
    }

    database_flags {
      name  = "max_connections"
      value = var.sql_max_connections
    }
    database_flags {
      name  = "autovacuum_freeze_max_age"
      value = var.autovacuum_freeze_max_age
    }
    database_flags {
      name  = "max_replication_slots"
      value = var.max_replication_slots
    }
    database_flags {
      name  = "cloudsql.logical_decoding"
      value = var.logical_decoding
    }

    user_labels = {
      "owned_by" = var.name
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length     = var.query_string_length
      record_application_tags = true
      record_client_address   = true
    }
  }

  timeouts {
    create = "10m"
  }
}

resource "google_sql_database" "main" {
  project  = var.project
  name     = var.name
  instance = google_sql_database_instance.master.name

  timeouts {
    create = "10m"
  }
}

resource "random_string" "db_sql_password" {
  length  = 16
  special = false
}

resource "google_sql_user" "main" {
  project  = var.project
  name     = var.username
  instance = google_sql_database_instance.master.name
  password = random_string.db_sql_password.result
}

resource "google_secret_manager_secret" "db_account_secret" {
  secret_id = "${var.name}_${var.username}_password"
  project   = var.project

  labels = {
    type     = "database_user_password"
    database = var.name
    user     = var.username
  }

  replication {
    automatic = true
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      project
    ]
  }
}

resource "google_secret_manager_secret_version" "db_account_secret_version" {
  secret      = google_secret_manager_secret.db_account_secret.id
  secret_data = random_string.db_sql_password.result
}

resource "google_secret_manager_secret" "connection_string_secret" {
  secret_id = "${var.name}_${var.username}_connection_string"
  project   = var.project

  labels = {
    type     = "database_connection_string"
    database = var.name
    user     = var.username
  }

  replication {
    automatic = true
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      project
    ]
  }
}

resource "google_secret_manager_secret_version" "connection_string_secret_version" {
  secret      = google_secret_manager_secret.connection_string_secret.id
  secret_data = "postgresql://${google_sql_user.main.name}:${nonsensitive(google_sql_user.main.password)}@${google_sql_database_instance.master.private_ip_address}/${google_sql_database.main.name}"
}

resource "google_secret_manager_secret" "public_connection_string_secret" {
  secret_id = "${var.name}_${var.username}_public_connection_string"
  project   = var.project

  labels = {
    type     = "public_database_connection_string"
    database = var.name
    user     = var.username
  }

  replication {
    automatic = true
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      project
    ]
  }
}

resource "google_secret_manager_secret_version" "public_connection_string_secret_version" {
  secret      = google_secret_manager_secret.public_connection_string_secret.id
  secret_data = "postgresql://${google_sql_user.main.name}:${nonsensitive(google_sql_user.main.password)}@localhost/${google_sql_database.main.name}?host=/cloudsql/${google_sql_database_instance.master.connection_name}"
}
