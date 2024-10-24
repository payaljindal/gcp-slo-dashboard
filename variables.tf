variable "services" {
  description = "Mapping of services with their SLO filters"
  type = map(object({
    service_display_name = string
    slo_filters = list(object({
        slo_id                = string
        goal                  = number
        display_name          = string
        slo_type              = string
        good_service_filter   = optional(string)
        total_service_filter  = optional(string)
        good_bad_metric_filter = optional(string)
        window_period          = optional(string)
        alert_policy_conditions  = optional(object({
            condition_display_name = string
            aggregations           = map(any)
            comparison             = string
            threshold_value        = string
            trigger_count          = string
            trigger_percent        = string
            threshold_duration     = string
            alignment_period       = string
        }))
      }))
  }))
}

variable "notification_channels" {
  description = "Policy notification channel uses to notify you that the conditions of an alerting policy have been met."
  type        = map(any)
  default     = {}
}

variable "project_id" {
  description = "Project ID to host this Apigee organization (will also become the Apigee Org name)."
  type        = string
}