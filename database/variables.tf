variable "project" {
  type        = string
  description = "The project name"
}

variable "region" {
  type = string
}

variable "name" {
  type    = string
  default = "standin"
}

variable "username" {
  type    = string
  default = "standin"
}

variable "sql_machine_type" {
  type    = string
  default = "db-f1-micro"
}

variable "sql_disk_size" {
  type    = string
  default = 10
}

variable "sql_max_connections" {
  type    = string
  default = 50
}

variable "autovacuum_freeze_max_age" {
  type        = number
  description = "Specifies the maximum age (in transactions) that a table's pg_class.relfrozenxid field can attain before a VACUUM operation is forced to prevent transaction ID wraparound within the table. Recommended at 500000000 https://github.com/jberkus/annotated.conf/blob/master/annotated.csv#L149"
  default     = 500000000
}

variable "logical_decoding" {
  type    = string
  default = "on"
}

variable "max_replication_slots" {
  type    = number
  default = 10
}

variable "private_network" {
  type        = string
  description = "The private network in which this resource will live"
}

variable "database_version" {
  type        = string
  description = "The version of the database to run"
  default     = "POSTGRES_14"
}

variable "deletion_protection" {
  type        = bool
  description = "Should this database be prevented from being deleted"
  default     = true
}

variable "max_standby_streaming_delay" {
  type        = number
  description = "Sets the maximum delay (in ms) before canceling queries when a hot standby server is processing streamed WAL data"
  default     = 3600000
}

variable "max_standby_archive_delay" {
  type        = number
  description = "Sets the maximum delay (in ms) before canceling queries when a hot standby server is processing archived WAL data"
  default     = 3600000
}

variable "alert_notification_channels" {
  type        = list(string)
  description = "The alert channel to publish alerts to"
  default     = []
}

variable "query_string_length" {
  type        = number
  description = "Sets the maximum query string length that is logged in query insights"
  default     = 1024
}
