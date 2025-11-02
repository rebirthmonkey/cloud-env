### inputs

```bash

  logsets = {
    cloud_audit = {
      logset_name = local.env_vars.locals.security.cloud_audit.logset_name
      topics = local.env_vars.locals.security.cloud_audit.topics
    }
    ckafka = {
      logset_name = local.env_vars.locals.ckafka.log.logset_name
      topics = local.env_vars.locals.ckafka.log.topics
    }
    alert_platform = {
      logset_name = local.env_vars.locals.monitoring.alarm.log_set.platform_alert_set.name
      topics = {
        for k, topic in local.env_vars.locals.monitoring.alarm.log_set.platform_alert_set.topics: k => {
          topic_name           = topic.name
          describes = try(topic.describes, null)
          auto_split           = true // Whether to enable automatic split. Default value: true.
          max_split_partitions = 50
          // Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50.
          partition_count      = 1 // Number of log topic partitions. Default value: 1. Maximum value: 10.
          period               = topic.period // Lifecycle in days. Value range: 1~366. Default value: 30.
          hot_period = topic.hot_period
          storage_type         = "hot"
          // Log topic storage class. Valid values: hot: real-time storage; cold: offline storage. Default value: hot. If cold is passed in, please contact the customer service to add the log topic to the allowlist first..
          tags                 = merge(local.tags, {})
        }
      }
    }
    alert_uptimecheck = {
      logset_name = local.env_vars.locals.monitoring.alarm.log_set.uptime_check_log.name
      topics = {
        for k, topic in local.env_vars.locals.monitoring.alarm.log_set.uptime_check_log.topics: k => {
          topic_name           = topic.name
          describes = try(topic.describes, null)
          auto_split           = true // Whether to enable automatic split. Default value: true.
          max_split_partitions = 50
          // Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50.
          partition_count      = 1 // Number of log topic partitions. Default value: 1. Maximum value: 10.
          period               = topic.period // Lifecycle in days. Value range: 1~366. Default value: 30.
          hot_period = topic.hot_period
          storage_type         = "hot"
          // Log topic storage class. Valid values: hot: real-time storage; cold: offline storage. Default value: hot. If cold is passed in, please contact the customer service to add the log topic to the allowlist first..
          tags                 = merge(local.tags, {})
        }
      }
    }
    tke = {
      logset_name = local.tke_cluster_name
      topics = {
        event = {
          topic_name            = format("%s-%s", local.tke_cluster_name, "event")
          auto_split            = true // Whether to enable automatic split. Default value: true.
          max_split_partitions  = 50 // Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50.
          partition_count = 1 // Number of log topic partitions. Default value: 1. Maximum value: 10.
          period                = 400 // Lifecycle in days. Value range: 1~366. Default value: 30.
          hot_period = 90
          storage_type = "hot" // Log topic storage class. Valid values: hot: real-time storage; cold: offline storage. Default value: hot. If cold is passed in, please contact the customer service to add the log topic to the allowlist first..
          tags                  = merge(local.tags, {})
        }
        audit = {
          topic_name            = format("%s-%s", local.tke_cluster_name, "audit")
          auto_split            = true // Whether to enable automatic split. Default value: true.
          max_split_partitions  = 50 // Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50.
          partition_count = 1 // Number of log topic partitions. Default value: 1. Maximum value: 10.
          period                = 400 // Lifecycle in days. Value range: 1~366. Default value: 30.
          hot_period = 90
          storage_type = "hot" // Log topic storage class. Valid values: hot: real-time storage; cold: offline storage. Default value: hot. If cold is passed in, please contact the customer service to add the log topic to the allowlist first..
          tags                  = merge(local.tags, {})
        }
      }
    }
    vpc_flow_log = {
      logset_name = "vpc_flow_log"
      topics = {
        vpc_flow_log = {
          topic_name            = "vpc_flow_log"
          auto_split            = true // Whether to enable automatic split. Default value: true.
          max_split_partitions  = 50 // Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50.
          partition_count = 1 // Number of log topic partitions. Default value: 1. Maximum value: 10.
          period                = 400 // Lifecycle in days. Value range: 1~366. Default value: 30.
          hot_period = 90
          storage_type = "hot" // Log topic storage class. Valid values: hot: real-time storage; cold: offline storage. Default value: hot. If cold is passed in, please contact the customer service to add the log topic to the allowlist first..
          tags                  = merge(local.tags, {})
        }
      }
    }
  }

  alarms = local.env_vars.locals.monitoring.cls_alarm.alarms // default {}


  tags = local.tags // default {}
```