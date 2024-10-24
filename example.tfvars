services = {
  "tf-service1" = {
    service_display_name = "tf-svc1"
    slo_filters  = [
      {
        slo_id       = "slo_12"
        goal = 0.99
        display_name = "slo 2"
        slo_type              = "request_based" 
        good_service_filter  = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
        total_service_filter = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
        alert_policy_conditions = {
          condition_display_name = "Burn Rate on slo_2 service tf-svc12"
          comparison       = "COMPARISON_GT"
          threshold_duration = "60s"
          alignment_period = "300s"
          threshold_value = 1
          trigger_count   = "1"
          trigger_percent = "0"
          aggregations = {}
        }
      },
    ]
  }
}

notification_channels = {
  "email_admin" = {
    channel_display_name = "Admin Channel"
    channel_type         = "email"
    channel_destination  = "text@example.com"
    channel_enabled      = "true"
  }
}

project_id = "<project_id>"