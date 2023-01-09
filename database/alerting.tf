# # Alert if database cpu goes over 90% for over 5 minutes
# resource "google_monitoring_alert_policy" "cpu_utilization_policy" {
#   count        = length(var.alert_notification_channels) > 0 ? 1 : 0
#   display_name = "${var.name} Sql - Cpu Utilization"
#   combiner     = "OR"
#   conditions {
#     display_name = "cpu utilization"
#     condition_threshold {
#       filter = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.project}:${google_sql_database_instance.master.name}\" AND metric.type = \"cloudsql.googleapis.com/database/cpu/utilization\""
#       aggregations {
#         alignment_period   = "300s"
#         per_series_aligner = "ALIGN_MEAN"
#       }
#       comparison = "COMPARISON_GT"
#       duration   = "300s"
#       trigger {
#         count = 1
#       }
#       threshold_value = 0.9
#     }
#   }
#   alert_strategy {
#     auto_close = "1800s"
#   }

#   notification_channels = var.alert_notification_channels

#   user_labels = {
#     service = "${var.name}"
#   }

#   documentation {
#     content = <<EOT
#     # What does this mean?
#     The cpu usage of the database for ${var.name} (${google_sql_database_instance.master.name}) has been over 90% for the last 5 minutes. 
#     # How worrying is this?
#     Cpu usage on the database should not be this high for this long. This should be investigated.
#     EOT
#   }
# }

# # Alert if database disk utilization goes over 95% for over 5 minutes
# resource "google_monitoring_alert_policy" "disk_utilization_policy" {
#   count        = length(var.alert_notification_channels) > 0 ? 1 : 0
#   display_name = "${var.name} Sql - Disk Utilization"
#   combiner     = "OR"
#   conditions {
#     display_name = "disk utilization"
#     condition_threshold {
#       filter = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.project}:${google_sql_database_instance.master.name}\" AND metric.type = \"cloudsql.googleapis.com/database/disk/utilization\""
#       aggregations {
#         alignment_period   = "300s"
#         per_series_aligner = "ALIGN_MEAN"
#       }
#       comparison = "COMPARISON_GT"
#       duration   = "300s"
#       trigger {
#         count = 1
#       }
#       threshold_value = 0.95
#     }
#   }
#   alert_strategy {
#     auto_close = "1800s"
#   }

#   notification_channels = var.alert_notification_channels

#   user_labels = {
#     service = "${var.name}"
#   }

#   documentation {
#     content = <<EOT
#     # What does this mean?
#     The disk usage of the database for ${var.name} (${google_sql_database_instance.master.name}) has been over 95% for the last 5 minutes. 
#     # How worrying is this?
#     The disk should have auto expanded by now. Best go check it
#     EOT
#   }
# }

# Alert if database read io goes over 500k for over 5 minutes
# resource "google_monitoring_alert_policy" "read_io_policy" {
#   count        = length(var.alert_notification_channels) > 0 ? 1 : 0
#   display_name = "${var.name} Sql - Read IO"
#   combiner     = "OR"
#   conditions {
#     display_name = "read io"
#     condition_threshold {
#       filter = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.project}:${google_sql_database_instance.master.name}\" AND metric.type = \"cloudsql.googleapis.com/database/disk/read_ops_count\""
#       aggregations {
#         alignment_period   = "300s"
#         per_series_aligner = "ALIGN_MEAN"
#       }
#       comparison = "COMPARISON_GT"
#       duration   = "300s"
#       trigger {
#         count = 1
#       }
#       threshold_value = 500000
#     }
#   }
#   alert_strategy {
#     auto_close = "1800s"
#   }

#   notification_channels = var.alert_notification_channels

#   user_labels = {
#     service = "${var.name}"
#   }

#   documentation {
#     content = <<EOT
#     # What does this mean?
#     The Read IO of the database for ${var.name} (${google_sql_database_instance.master.name}) has been over 500k for the last 5 minutes. 
#     # How worrying is this?
#     Not entirely sure, best just keep an eye on it and run some checks. Look at the query insights to see if somethings going crazy
#     EOT
#   }
# }

# # Alert if database write io goes over 150k for over 5 minutes
# resource "google_monitoring_alert_policy" "write_io_policy" {
#   count        = length(var.alert_notification_channels) > 0 ? 1 : 0
#   display_name = "${var.name} Sql - Write IO"
#   combiner     = "OR"
#   conditions {
#     display_name = "write io"
#     condition_threshold {
#       filter = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.project}:${google_sql_database_instance.master.name}\" AND metric.type = \"cloudsql.googleapis.com/database/disk/write_ops_count\""
#       aggregations {
#         alignment_period   = "300s"
#         per_series_aligner = "ALIGN_MEAN"
#       }
#       comparison = "COMPARISON_GT"
#       duration   = "300s"
#       trigger {
#         count = 1
#       }
#       threshold_value = 150000
#     }
#   }
#   alert_strategy {
#     auto_close = "1800s"
#   }

#   notification_channels = var.alert_notification_channels

#   user_labels = {
#     service = "${var.name}"
#   }

#   documentation {
#     content = <<EOT
#     # What does this mean?
#     The Write IO of the database for ${var.name} (${google_sql_database_instance.master.name}) has been over 150k for the last 5 minutes. 
#     # How worrying is this?
#     Not entirely sure, best just keep an eye on it and run some checks. Look at the query insights to see if somethings going crazy
#     EOT
#   }
# }

# # Alert if database memory utilization goes over 80% for over 5 minutes
# resource "google_monitoring_alert_policy" "memory_utilization_policy" {
#   count        = length(var.alert_notification_channels) > 0 ? 1 : 0
#   display_name = "${var.name} Sql - Memory Utilization"
#   combiner     = "OR"

#   conditions {
#     display_name = "memory utilization"

#     condition_threshold {
#       filter = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.project}:${google_sql_database_instance.master.name}\" AND metric.type = \"cloudsql.googleapis.com/database/memory/utilization\""
#       aggregations {
#         alignment_period   = "300s"
#         per_series_aligner = "ALIGN_MEAN"
#       }
#       comparison = "COMPARISON_GT"
#       duration   = "300s"
#       trigger {
#         count = 1
#       }
#       threshold_value = 0.8
#     }
#   }
#   alert_strategy {
#     auto_close = "1800s"
#   }

#   notification_channels = var.alert_notification_channels

#   user_labels = {
#     service = "${var.name}"
#   }

#   documentation {
#     content = <<EOT
#     # What does this mean?
#     The Memory utilization of the database for ${var.name} (${google_sql_database_instance.master.name}) has been over 80% for the last 5 minutes. 
#     # How worrying is this?
#     Memory will not automatically expand so the db needs checking on.
#     EOT
#   }
# }



