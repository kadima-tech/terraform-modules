output "name" {
  value = google_sql_database.main.name
}

output "instance" {
  value = google_sql_database_instance.master.name
}

output "ip_address" {
  value = google_sql_database_instance.master.private_ip_address
}

output "username" {
  value = google_sql_user.main.name
}

output "password" {
  value = nonsensitive(google_sql_user.main.password)
}

output "password_secret" {
  value = google_secret_manager_secret.db_account_secret.id
}

output "connection_string_secret" {
  value = google_secret_manager_secret.connection_string_secret.id
}

output "public_connection_string_secret" {
  value = google_secret_manager_secret.public_connection_string_secret.id
}

output "connection_string" {
  value = "postgresql://${google_sql_user.main.name}:${nonsensitive(google_sql_user.main.password)}@${google_sql_database_instance.master.private_ip_address}/${google_sql_database.main.name}"
}

output "connection_name" {
  value = google_sql_database_instance.master.connection_name
}
