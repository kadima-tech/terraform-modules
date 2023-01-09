variable "project" {
  type        = string
  description = "The id of the project we want to enable cloudrun on"
}

variable "gcloud_project_number" {
  type        = number
  description = "The number of the project we want to enable cloudrun on"
}

variable "container_registry_project" {
  type        = string
  description = "The id of the project we want to store docker containers in"
}
