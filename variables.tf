variable "services" {
  description = "Mapping of services with their SLO filters"
  type = map(object({
    service_display_name = string
    slo_filters  = list(object({
      slo_id              = string
      display_name        = string
      good_service_filter = string
      total_service_filter = string
      goal                 = number
    }))
  }))
}
