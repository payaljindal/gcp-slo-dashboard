locals {
  flattened_services = flatten([
    for service_key, service in var.services : [
      for filter in service.slo_filters : {
        service_display_name = service.service_display_name
        service_id = service_key
        slo_id       = filter.slo_id
        goal         = filter.goal
        fliter_display_name = filter.display_name
        good_service_filter  = filter.good_service_filter
        total_service_filter = filter.total_service_filter 
      }
    ]
  ])
}

resource "google_monitoring_custom_service" "service" {
  for_each = var.services
  service_id   = each.key
  display_name = each.value.service_display_name
}

resource "google_monitoring_slo" "availability_load_balancer" {
  for_each = { for slo in local.flattened_services : "${slo.service_id}-${slo.slo_id}" => slo }

  service      = each.value.service_id
  slo_id       = each.value.slo_id
  display_name = each.value.fliter_display_name

  request_based_sli {
    good_total_ratio {
      good_service_filter = each.value.good_service_filter
      total_service_filter = each.value.total_service_filter
    }
  }

  goal                = each.value.goal 
  rolling_period_days = 28
  depends_on = [google_monitoring_custom_service.service] 
}