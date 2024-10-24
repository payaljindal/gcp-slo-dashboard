locals {
  flattened_services = flatten([
    for service_key, service in var.services : [
      for filter in service.slo_filters : {
        service_display_name = service.service_display_name
        service_id = service_key
        slo_id       = filter.slo_id
        goal         = filter.goal
        filter_display_name = filter.display_name
        good_service_filter  = filter.good_service_filter
        total_service_filter = filter.total_service_filter 
        good_bad_metric_filter = filter.good_bad_metric_filter
        window_period = filter.window_period
        slo_type = filter.slo_type
        alert_policy_conditions = filter.alert_policy_conditions
        slo_name = "projects/${var.project_id}/services/${service_key}/serviceLevelObjectives/${filter.slo_id}" 
      }
    ]
  ])

  notification_channels = [
    for channel in google_monitoring_notification_channel.alert_notification_channel :
    channel.id
  ]
}

resource "google_monitoring_notification_channel" "alert_notification_channel" {
  project      = var.project_id
  for_each     = var.notification_channels
  type         = each.value.channel_type
  display_name = each.value.channel_display_name
  enabled      = each.value.channel_enabled

  labels = {
    email_address = each.value.channel_destination
  }
}

resource "google_monitoring_custom_service" "service" {
  project = var.project_id
  for_each = var.services
  service_id   = each.key
  display_name = each.value.service_display_name
}

resource "google_monitoring_slo" "slo" {
  project = var.project_id
  for_each = { for slo in local.flattened_services : "${slo.service_id}-${slo.slo_id}" => slo }

  service      = each.value.service_id
  slo_id       = each.value.slo_id
  display_name = each.value.filter_display_name

  dynamic "request_based_sli" {
    for_each = each.value.slo_type == "request_based" ? [1] : []
    content {
      good_total_ratio {
        good_service_filter = each.value.good_service_filter
        total_service_filter = each.value.total_service_filter
      }
    }
  }
  dynamic "windows_based_sli" {
    for_each = each.value.slo_type == "windows_based" ? [1] : []
    content {
      good_bad_metric_filter = each.value.good_bad_metric_filter
      window_period         = each.value.window_period
    }
  }
  goal                = each.value.goal 
  rolling_period_days = 28
  depends_on = [google_monitoring_custom_service.service] 
}

resource "google_monitoring_alert_policy" "alert_policy" {
  project = var.project_id
  for_each = { for slo in local.flattened_services : "${slo.service_id}-${slo.slo_id}" => slo if slo.alert_policy_conditions != null }
  display_name = each.value.alert_policy_conditions.condition_display_name
  combiner     = "OR"
  conditions {
    display_name = each.value.alert_policy_conditions.condition_display_name
    condition_threshold {
      filter = "select_slo_burn_rate(\"${each.value.slo_name}\", \"${each.value.alert_policy_conditions.alignment_period}\")" 
      comparison = each.value.alert_policy_conditions.comparison
      threshold_value = each.value.alert_policy_conditions.threshold_value
      duration        = each.value.alert_policy_conditions.threshold_duration

      dynamic "aggregations" {
        for_each = each.value.alert_policy_conditions.aggregations
        content {
          alignment_period     = aggregations.value.alignment_period
          per_series_aligner   = aggregations.value.per_series_aligner
          cross_series_reducer = aggregations.value.cross_series_reducer
          group_by_fields      = aggregations.value.group_by_fields
        }
      }

      trigger {
        count   = each.value.alert_policy_conditions.trigger_count
        percent = each.value.alert_policy_conditions.trigger_percent
      }
    }
  }
 notification_channels = local.notification_channels
 depends_on = [google_monitoring_slo.slo] 
}