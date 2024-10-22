services = {
  "test_service_tf" = {
    service_display_name = "tf-service"
    slo_filters  = [
      {
        slo_id       = "slo_1"
        goal = 0.99
        display_name = "slo 1"
        good_service_filter  = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
        total_service_filter = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
      },
      {
        slo_id       = "slo_2"
        goal = 0.97
        display_name = "slo 2"
        good_service_filter  = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
        total_service_filter = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
      },
    ]
  },
  "test_service_tf3" = {
    service_display_name = "tf-service3"
    slo_filters  = [
      {
        slo_id       = "slo_1"
        goal = 0.99
        display_name = "slo 1"
        good_service_filter  = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
        total_service_filter = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
      },
      {
        slo_id       = "slo_2"
        goal = 0.97
        display_name = "slo 2"
        good_service_filter  = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
        total_service_filter = "metric.type=\"apigee.googleapis.com/proxyv2/response_count\" resource.type=\"apigee.googleapis.com/ProxyV2\""
      },
    ]
  }
}
