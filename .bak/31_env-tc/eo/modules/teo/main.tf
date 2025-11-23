
locals {
  need_verify = var.need_verify
  zone_verified = ! local.need_verify
  zone_id = var.create_zone ? concat(tencentcloud_teo_zone.zone.*.id, [""])[0] : var.zone_id

  // we can not create domains or certificates if zone is not verified
  acceleration_domains = {for k, ad in var.acceleration_domains: k => ad if local.zone_verified}
  certificates = {for k, cert in var.certificates: k => cert if local.zone_verified}
  origin_ids = {for k, origin in tencentcloud_teo_origin_group.origin_groups: origin.name => origin.origin_group_id}
}


resource "tencentcloud_teo_zone" "zone" {
  count = var.create_zone ? 1 : 0
  zone_name       = var.zone_name // "tmigrate.com"
  type            = var.type // "partial"
  area            = var.area // "mainland"
  alias_zone_name = var.alias_zone_name // "tmigrate"
  paused          = var.paused // false
  plan_id         = var.plan_id // "edgeone-2o4lesofla4k"
  tags = var.tags
  lifecycle {
    ignore_changes = [
      ownership_verification // this value is computed
    ]
  }
}


resource "tencentcloud_teo_origin_group" "origin_groups" {
  for_each = var.origin_groups

  name    = try(each.value.origin_group_name, each.key)
  type    = try(each.value.origin_type, "GENERAL")
  zone_id = local.zone_id

  dynamic records {
    for_each = try(each.value.origin_records, {})
    content {
      record  = try(records.value.record, "1.2.3.4")
      // Record value, which could be an IPv4/IPv6 address or a domain.
      type    = try(records.value.type, "IP_DOMAIN")
      weight  = try(records.value.weight, 100)
      private = try(records.value.private, true)

      dynamic private_parameters {
        for_each = try(records.value.private_parameter, [
          {
            name  = "Region"
            value = ""
          },
          {
            name  = "SignatureVersion"
            value = "v4"
          }
        ])
        content {
          name  = try(private_parameters.value.name, null)
          value = try(private_parameters.value.value, null)
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "null_resource" "always" {
  count = var.create_zone && local.need_verify? 1 : 0
  triggers = {
    hour = timestamp()
  }
}

resource "tencentcloud_teo_ownership_verify" "ownership_verify" {
  count = var.create_zone && local.need_verify? 1 : 0
  depends_on = [ tencentcloud_teo_zone.zone ]
  domain = concat(null_resource.always.*.id, [""])[0] == concat(null_resource.always.*.id, [""])[0] ? var.zone_name: ""
}


resource "tencentcloud_teo_acceleration_domain" "acceleration_domain" {
  for_each = local.acceleration_domains
  zone_id     = local.zone_id
  domain_name = try(each.value.domain_name, each.key) //"test8.tmigrate.com"
  status = try(each.value.status, "online") // online: enabled; offline: disabled.
  origin_protocol = try(each.value.origin_protocol, "FOLLOW") # FOLLOW, HTTP, HTTPS
  http_origin_port = try(each.value.http_origin_port, null)
  https_origin_port = try(each.value.https_origin_port, null)

    dynamic "origin_info" {
    for_each = try(each.value.origin_info, {})
    content {
      origin      = lookup(local.origin_ids, origin_info.value.origin, origin_info.value.origin)
      origin_type = try(origin_info.value.origin_type, "ORIGIN_GROUP")
      // IP_DOMAIN: IPv4/IPv6 address or domain name; COS: COS bucket address; ORIGIN_GROUP: Origin group; AWS_S3: AWS S3 bucket address; SPACE: EdgeOne Shield Space.
      backup_origin = try(origin_info.value.backup_origin, null)
      private_access = try(origin_info.value.private_access, null)
      dynamic "private_parameters" {
        for_each = try(origin_info.value.private_parameters, {})
        content {
          name = private_parameters.value.name
          value = private_parameters.value.value
        }
      }
    }
  }
}

# deprecated
#resource "tencentcloud_teo_zone_setting" "zone_setting" {
#  count = var.zone_settings != {} ? 1 : 0
#  zone_id = local.zone_id
#  smart_routing {
#    switch = try(var.zone_settings.smart_routing.switch, "on")
#  }
#  offline_cache {
#    switch = try(var.zone_settings.offline_cache.switch, "on")
#  }
#
#  force_redirect {
#    redirect_status_code = try(var.zone_settings.force_redirect.redirect_status_code, 301)
#    switch               = try(var.zone_settings.force_redirect.switch, "on")
#  }
#
#  upstream_http2 {
#    switch = try(var.zone_settings.upstream_http2.switch, "off")
#  }
#  https {
#    http2         = try(var.zone_settings.https.http2, "on")
#    ocsp_stapling = try(var.zone_settings.https.ocsp_stapling, "off")
#    tls_version = try(var.zone_settings.https.tls_version, [
#      "TLSv1",
#      "TLSv1.1",
#      "TLSv1.2",
#      "TLSv1.3",
#    ])
#
#    hsts {
#      include_sub_domains = try(var.zone_settings.https.hsts.include_sub_domains, "off")
#      max_age             = try(var.zone_settings.https.hsts.max_age, 16070400) // s, = 186 days
#      preload             = try(var.zone_settings.https.hsts.preload, "off")
#      switch              = try(var.zone_settings.https.hsts.switch, "on")
#    }
#  }
#
#  post_max_size {
#    max_size = try(var.zone_settings.post_max_size.max_size,838860800)  // 800M
#    switch   = try(var.zone_settings.post_max_size.switch,"on")
#  }
#}

resource "tencentcloud_teo_l7_acc_setting" "teo_l7_acc_setting" {
  count = var.l7_acc_setting != {} ? 1 : 0
  zone_id = local.zone_id
  zone_config {
    accelerate_mainland {
      switch = try(var.l7_acc_setting.zone_config.accelerate_mainland.switch, "on")
    }
    cache {
      custom_time {
        cache_time = try(var.l7_acc_setting.zone_config.cache.custom_time.cache_time, 2592000)
        switch     = try(var.l7_acc_setting.zone_config.cache.cache_time.switch, "off")
      }
      follow_origin {
        default_cache          = try(var.l7_acc_setting.zone_config.cache.follow_origin.default_cache, "off")
        default_cache_strategy = try(var.l7_acc_setting.zone_config.cache.follow_origin.default_cache_strategy, "on")
        default_cache_time     = try(var.l7_acc_setting.zone_config.cache.follow_origin.default_cache_time, 0)
        switch                 = try(var.l7_acc_setting.zone_config.cache.follow_origin.switch, "on")
      }
      no_cache {
        switch = try(var.l7_acc_setting.zone_config.cache.no_cache.switch, "off")
      }
    }
    cache_key {
      full_url_cache = try(var.l7_acc_setting.zone_config.cache_key.full_url_cache ,"on")
      ignore_case    = try(var.l7_acc_setting.zone_config.cache_key.ignore_case, "off")
      query_string {
        action = try(var.l7_acc_setting.zone_config.cache_key.query_string.action, "includeCustom")
        switch = try(var.l7_acc_setting.zone_config.cache_key.query_string.switch, "off")
        values = try(var.l7_acc_setting.zone_config.cache_key.query_string.values, [])
      }
    }
    cache_prefresh {
      cache_time_percent = try(var.l7_acc_setting.zone_config.cache_prefresh.cache_time_percent, 90)
      switch             = try(var.l7_acc_setting.zone_config.cache_prefresh.switch, "off")
    }
    client_ip_country {
      switch = try(var.l7_acc_setting.zone_config.client_ip_country.switch ,"off")
      header_name = try(var.l7_acc_setting.zone_config.client_ip_country.header_name, null)
    }
    client_ip_header {
      switch = try(var.l7_acc_setting.zone_config.client_ip_header.switch, "off")
    }
    compression {
      algorithms = try(var.l7_acc_setting.zone_config.compression.algorithms, ["brotli", "gzip"])
      switch     = try(var.l7_acc_setting.zone_config.compression.switch, "on")
    }
    force_redirect_https {
      redirect_status_code = try(var.l7_acc_setting.zone_config.force_redirect_https.redirect_status_code, 302)
      switch               = try(var.l7_acc_setting.zone_config.force_redirect_https.switch, "off")
    }
    grpc {
      switch = try(var.l7_acc_setting.zone_config.grpc.switch, "off")
    }
    hsts {
      include_sub_domains = try(var.l7_acc_setting.zone_config.hsts.include_sub_domains, "off")
      preload             = try(var.l7_acc_setting.zone_config.hsts.preload, "off")
      switch              = try(var.l7_acc_setting.zone_config.hsts.switch, "on")
      timeout             = try(var.l7_acc_setting.zone_config.hsts.timeout, 16070400)
    }
    http2 {
      switch = try(var.l7_acc_setting.zone_config.http2.switch, "off")
    }
    ipv6 {
      switch = try(var.l7_acc_setting.zone_config.ipv6.switch, "off")
    }
    max_age {
      cache_time    = try(var.l7_acc_setting.zone_config.max_age.cache_time, 600)
      follow_origin = try(var.l7_acc_setting.zone_config.max_age.follow_origin, "on")
    }
    ocsp_stapling {
      switch = try(var.l7_acc_setting.zone_config.ocsp_stapling.switch, "off")
    }
    offline_cache {
      switch = try(var.l7_acc_setting.zone_config.offline_cache.switch, "on")
    }
    post_max_size {
      max_size = try(var.l7_acc_setting.zone_config.post_max_size.max_size, 838860800)
      switch   = try(var.l7_acc_setting.zone_config.post_max_size.switch, "on")
    }
    quic {
      switch = try(var.l7_acc_setting.zone_config.quic.switch, "off")
    }
    smart_routing {
      switch = try(var.l7_acc_setting.zone_config.smart_routing.switch, "off")
    }
    standard_debug {
      allow_client_ip_list = try(var.l7_acc_setting.zone_config.standard_debug.allow_client_ip_list, [])
      expires              =try(var.l7_acc_setting.zone_config.standard_debug.expires,  "1969-12-31T16:00:00Z")
      switch               = try(var.l7_acc_setting.zone_config.standard_debug.switch, "off")
    }
    tls_config {
      cipher_suite = try(var.l7_acc_setting.zone_config.tls_config.cipher_suite,  "loose-v2023")
      version      = try(var.l7_acc_setting.zone_config.tls_config.version, ["TLSv1", "TLSv1.1", "TLSv1.2", "TLSv1.3"])
    }
    upstream_http2 {
      switch = try(var.l7_acc_setting.zone_config.upstream_http2.switch, "off")
    }
    web_socket {
      switch  = try(var.l7_acc_setting.zone_config.web_socket.switch, "off")
      timeout = try(var.l7_acc_setting.zone_config.web_socket.timeout, 30)
    }
  }
}

// Deprecated
resource "tencentcloud_teo_rule_engine" "rules" {
  count = length(var.rule_engines)
  zone_id   = local.zone_id
  rule_name = var.rule_engines[count.index].rule_name
  status    = var.rule_engines[count.index].status

  dynamic rules {
    for_each = var.rule_engines[count.index].rules
    content {
      dynamic actions {
        for_each = try(rules.value.actions, [])
        content {
          dynamic normal_action {
            for_each = actions.value.normal_action
            content {
              action = normal_action.value.action
              dynamic parameters {
                for_each = normal_action.value.parameters
                content {
                  name   = parameters.value.name
                  values = parameters.value.values
                }
              }
            }
          }
        }
      }
      dynamic or {
        for_each = try(rules.value.or, [])
        content {
          dynamic and {
            for_each = or.value
            content {
              operator    = and.value.operator
              target      = and.value.target
              ignore_case = and.value.ignore_case
              values      = and.value.values
              name = try(and.value.name, null)
            }
          }
        }
      }
      dynamic sub_rules {
        for_each = try(rules.value.sub_rules, [])
        content {
          dynamic rules {
            for_each = sub_rules.value.rules
            content {
              dynamic actions {
                for_each = rules.value.actions
                content {
                  dynamic normal_action {
                    for_each = actions.value.normal_action
                    content {
                      action = normal_action.value.action
                      dynamic parameters {
                        for_each = normal_action.value.parameters
                        content {
                          name   = parameters.value.name
                          values = parameters.value.values
                        }
                      }
                    }
                  }
                }
              }

              dynamic or {
                for_each = try(rules.value.or, [])
                content {
                  dynamic and {
                    for_each = or.value
                    content {
                      operator    = and.value.operator
                      target      = and.value.target
                      ignore_case = and.value.ignore_case
                      values      = and.value.values
                    }
                  }
                }
              }
            }
          }

          tags = try(sub_rules.value.tags, [])

        }
      }
    }
  }
}

resource "tencentcloud_teo_realtime_log_delivery" "teo_realtime_log_delivery" {
  for_each = var.teo_log_delivery
  zone_id  = var.zone_id
  area     = try(each.value.area, null)
  log_type = try(each.value.log_type, null)
  sample = try(each.value.sample, null)
  task_name = try(each.value.task_name, null)
  task_type = try(each.value.task_type, null)
  delivery_status = try(each.value.delivery_status, null)
  entity_list = try(each.value.entity_list, [])
  fields = try(each.value.fields, [])

  dynamic "custom_fields" {
    for_each = try(each.value.custom_fields, [])
    content {
      name  = custom_fields.value.name
      value = custom_fields.value.value
      enabled = try(custom_fields.value.enabled, false)
    }
  }

  dynamic "delivery_conditions" {
    for_each = try(each.value.delivery_conditions, [])
    content {
      dynamic "conditions" {
        for_each = lookup(delivery_conditions.value, "conditions", [] )
        content {
          key = try(conditions.value.key, null)
          operator = try(conditions.value.operator, null)
          value = try(conditions.value.value, null) //list
        }
      }
    }
  }

  dynamic "custom_endpoint" {
    for_each = try(each.value.custom_endpoint, [])
    content {
      url           = try(custom_endpoint.value.url, null)
      access_id     = try(custom_endpoint.value.access_id, null)
      access_key    = try(custom_endpoint.value.access_key, null)
      compress_type = try(custom_endpoint.value.compress_type, null)
      protocol      = try(custom_endpoint.value.protocol, null)
      dynamic "headers" {
        for_each = lookup(custom_endpoint,"headers",[] )
        content {
          name       = try(headers.values.name, "")
          value       = try(headers.values.value, "")
        }
      }
    }
  }

  dynamic "log_format" {
    for_each = try(each.value.log_format, [])
    content {
      format_type = try(log_format.value.format_type,"json")
      batch_prefix = try(log_format.value.batch_prefix, "")
      batch_suffix = try(log_format.value.batch_suffix, "")
      field_delimiter = try(log_format.value.field_delimiter, "")
      record_delimiter = try(log_format.value.record_delimiter, "")
      record_prefix = try(log_format.value.record_prefix, "")
      record_suffix = try(log_format.value.record_suffix, "")
    }
  }

  dynamic "cls" {
    for_each = try(each.value.cls, [])
    content {
      log_set_id     = cls.value.log_set_id
      log_set_region = cls.value.log_set_region
      topic_id       = cls.value.topic_id
    }
  }

  dynamic "s3" {
    for_each = try(each.value.s3, [])
    content {
      access_id  = try(s3.value.access_id, "")
      access_key = try(s3.value.access_key, "")
      bucket     = try(s3.value.bucket, "")
      endpoint   = try(s3.value.endpoint, "")
      region     = try(s3.value.region, "")
      compress_type = try(s3.value.compress_type, "")
    }
  }

}

resource "tencentcloud_teo_certificate_config" "certificate" {
  depends_on = [tencentcloud_teo_acceleration_domain.acceleration_domain]
  for_each = local.certificates
  host    = try(each.value.host, each.key ) // "test8.tmigrate.com"
  mode    = try(each.value.mode, "sslcert")
  zone_id = local.zone_id

  dynamic "server_cert_info" {
    for_each = try(each.value.server_cert_infos, {})
    content {
      cert_id = server_cert_info.value.cert_id
    }
  }
}

resource "tencentcloud_teo_l7_acc_rule" "teo_l7_acc_rule" {
  count = length(var.l7_acc_rules) > 0 ? 1 : 0
  zone_id = local.zone_id
  dynamic rules {
    for_each = var.l7_acc_rules
    content {
      description = try(rules.value.description, [])
      rule_name   = rules.value.rule_name
      status      = try(rules.value.status, "enable")
      dynamic branches {
        for_each = rules.value.branches
        content {
          condition = branches.value.condition # "$${http.request.host} in ['aaa.makn.cn']"
          dynamic actions {
            for_each = branches.value.actions
            content {
              name = actions.value.name
              dynamic access_url_redirect_parameters {
                for_each = try(actions.value.access_url_redirect_parameters, null) == null ? [] : [1]
                content {
                  protocol = try(actions.value.access_url_redirect_parameters.protocol, "follow")
                  status_code = try(actions.value.access_url_redirect_parameters.status_code, 302)
                  host_name {
                    action = actions.value.access_url_redirect_parameters.host_name.action
                  }
                  query_string {
                    action = try(actions.value.access_url_redirect_parameters.query_string.action, "full")
                  }
                  url_path {
                    action = try(actions.value.access_url_redirect_parameters.url_path.action, "follow")
                  }
                }
              }
              dynamic cache_parameters {
                for_each = try(actions.value.cache_parameters, null) == null ? [] : [1]
                content {
                  dynamic follow_origin {
                    for_each = try(actions.value.cache_parameters.follow_origin, null) == null ? [] : [1]
                    content {
                      default_cache          = try(actions.value.cache_parameters.follow_origin.default_cache, "on")
                      default_cache_strategy = try(actions.value.cache_parameters.follow_origin.default_cache_strategy, "on")
                      default_cache_time     = try(actions.value.cache_parameters.follow_origin.default_cache_time, 0)
                      switch                 = try(actions.value.cache_parameters.follow_origin.switch, "on")
                    }
                  }
                  dynamic custom_time {
                    for_each = try(actions.value.cache_parameters.custom_time, null) == null ? [] : [1]
                    content {
                      cache_time           = try(actions.value.cache_parameters.custom_time.cache_time, 2592000)
                      ignore_cache_control = try(actions.value.cache_parameters.custom_time.ignore_cache_control, "off")
                      switch               = try(actions.value.cache_parameters.custom_time.switch, "on")
                    }
                  }
                  dynamic no_cache {
                    for_each = try(actions.value.cache_parameters.no_cache, null) == null ? [] : [1]
                    content {
                      switch               = try(actions.value.cache_parameters.no_cache.switch, "on")
                    }
                  }
                }
              }
              dynamic max_age_parameters {
                for_each = try(actions.value.max_age_parameters, null) == null ? [] : [1]
                content {
                  cache_time    = try(actions.value.max_age_parameters.cache_time, 0)
                  follow_origin = try(actions.value.max_age_parameters.follow_origin, "off")
                }
              }
              dynamic cache_key_parameters {
                for_each = try(actions.value.cache_key_parameters, null) == null ? [] : [1]
                content {
                  full_url_cache = try(actions.value.cache_key_parameters.full_url_cache, "on")
                  scheme = try(actions.value.cache_key_parameters.scheme,  "on")
                  query_string {
                    switch = try(actions.value.cache_key_parameters.query_string.switch, "off")
                    values = try(actions.value.cache_key_parameters.query_string.values, [])
                  }
                }
              }
              dynamic status_code_cache_parameters {
                for_each = try(actions.value.status_code_cache_parameters, null) == null ? [] : [1]
                content {
                  dynamic status_code_cache_params {
                    for_each = actions.value.status_code_cache_parameters.status_code_cache_params
                    content {
                      cache_time = status_code_cache_params.value.cache_time
                      status_code = status_code_cache_params.value.status_code
                    }
                  }
                }
              }
              dynamic offline_cache_parameters {
                for_each = try(actions.value.offline_cache_parameters, null) == null ? [] : [1]
                content {
                  switch = try(actions.value.offline_cache_parameters.switch, "on")
                }
              }
            }
          }
          dynamic sub_rules {
            for_each = try(branches.value.sub_rules, [])
            content {
              description = try(sub_rules.value.description, [])
              dynamic branches {
                for_each = sub_rules.value.branches
                // This block is always the same with rule.branches without sub_rules
                content {
                  condition = branches.value.condition # "$${http.request.host} in ['aaa.makn.cn']"
                  dynamic actions {
                    for_each = branches.value.actions
                    content {
                      name = actions.value.name
                      dynamic access_url_redirect_parameters {
                        for_each = try(actions.value.access_url_redirect_parameters, null) == null ? [] : [1]
                        content {
                          protocol = try(actions.value.access_url_redirect_parameters.protocol, "follow")
                          status_code = try(actions.value.access_url_redirect_parameters.status_code, 302)
                          host_name {
                            action = actions.value.access_url_redirect_parameters.host_name.action
                          }
                          query_string {
                            action = try(actions.value.access_url_redirect_parameters.query_string.action, "full")
                          }
                          url_path {
                            action = try(actions.value.access_url_redirect_parameters.url_path.action, "follow")
                          }
                        }
                      }
                      dynamic cache_parameters {
                        for_each = try(actions.value.cache_parameters, null) == null ? [] : [1]
                        content {
                          dynamic follow_origin {
                            for_each = try(actions.value.cache_parameters.follow_origin, null) == null ? [] : [1]
                            content {
                              default_cache          = try(actions.value.cache_parameters.follow_origin.default_cache, "on")
                              default_cache_strategy = try(actions.value.cache_parameters.follow_origin.default_cache_strategy, "on")
                              default_cache_time     = try(actions.value.cache_parameters.follow_origin.default_cache_time, 0)
                              switch                 = try(actions.value.cache_parameters.follow_origin.switch, "on")
                            }
                          }
                          dynamic custom_time {
                            for_each = try(actions.value.cache_parameters.custom_time, null) == null ? [] : [1]
                            content {
                              cache_time           = try(actions.value.cache_parameters.custom_time.cache_time, 2592000)
                              ignore_cache_control = try(actions.value.cache_parameters.custom_time.ignore_cache_control, "off")
                              switch               = try(actions.value.cache_parameters.custom_time.switch, "on")
                            }
                          }
                        }
                      }
                      dynamic max_age_parameters {
                        for_each = try(actions.value.max_age_parameters, null) == null ? [] : [1]
                        content {
                          cache_time    = try(actions.value.max_age_parameters.cache_time, 0)
                          follow_origin = try(actions.value.max_age_parameters.follow_origin, "off")
                        }
                      }
                      dynamic cache_key_parameters {
                        for_each = try(actions.value.cache_key_parameters, null) == null ? [] : [1]
                        content {
                          full_url_cache = try(actions.value.cache_key_parameters.full_url_cache, "on")
                          scheme = try(actions.value.cache_key_parameters.scheme,  "on")
                          query_string {
                            switch = try(actions.value.cache_key_parameters.query_string.switch, "off")
                            values = try(actions.value.cache_key_parameters.query_string.values, [])
                          }
                        }
                      }
                      dynamic status_code_cache_parameters {
                        for_each = try(actions.value.status_code_cache_parameters, null) == null ? [] : [1]
                        content {
                          dynamic status_code_cache_params {
                            for_each = actions.value.status_code_cache_parameters.status_code_cache_params
                            content {
                              cache_time = status_code_cache_params.value.cache_time
                              status_code = status_code_cache_params.value.status_code
                            }
                          }
                        }
                      }
                      dynamic offline_cache_parameters {
                        for_each = try(actions.value.offline_cache_parameters, null) == null ? [] : [1]
                        content {
                          switch = try(actions.value.offline_cache_parameters.switch, "on")
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

# conditions
# $${http.request.host} in ['aaa.makn.cn']
# $${http.request.uri.path} in ['/urlpath']
# $${http.request.full_uri} in ['https://aaa.makn.cn/fullurl']
# $${http.request.uri.args['string']} in ['search']
# $${http.request.file_extension} in ['suffix']
# $${http.request.filename} in ['filename']
# $${http.request.headers['User-Agent']} in ['httpheader']
# $${http.request.ip.country} in ['Asia']
# $${http.request.scheme} in ['http']
# $${http.request.ip} in ['1.2.3.4', '5.6.7.0/24']
# $${http.request.method} in ['HEAD', 'POST']"


resource "tencentcloud_teo_l4_proxy" "proxies" {
  for_each = var.l4_proxies
  accelerate_mainland = try(each.value.accelerate_mainland, "off")
  area                = try(each.value.area, "overseas")
  ipv6                = try(each.value.ipv6, "off")
  proxy_name          = each.value.proxy_name # "proxy-test"
  static_ip           = try(each.value.static_ip, "off")
  zone_id             = local.zone_id
}

locals {
#  l4_proxy_rules = {
#    for rule in flatten([
#      for l4_k, l4 in var.l4_proxies: [
#        for rule_k, rule in try(l4.rules, {}): merge({
#          l4_k = l4_k,
#          k = format("%s_%s", l4_k, rule_k)
#        }, rule)
#      ]
#    ]): rule.k => rule
#
#  }
  l4_proxy_rules = {
    for k, l4 in var.l4_proxies: k => l4 if length(try(l4.rules, [])) > 0
  }
 }
resource "tencentcloud_teo_l4_proxy_rule" "teo_l4_proxy_rule" {
  for_each = var.l4_proxies
  proxy_id = split("#", tencentcloud_teo_l4_proxy.proxies[each.key].id)[1] # "sid-38hbn26osico"
  zone_id  = local.zone_id

  dynamic l4_proxy_rules {
    for_each = each.value.rules
    content {
      client_ip_pass_through_mode = try(l4_proxy_rules.value.client_ip_pass_through_mode,  "OFF")
      origin_port_range           = try(l4_proxy_rules.value.origin_port_range, "1212")
      origin_type                 = try(l4_proxy_rules.value.origin_type, "IP_DOMAIN")
      origin_value                = try(l4_proxy_rules.value.origin_value, []) # [
#        "www.aaa.com",
#      ]
      port_range = try(l4_proxy_rules.value.port_range, []) #  [
#        "1212",
#      ]
      protocol             = try(l4_proxy_rules.value.protocol, "TCP")
      rule_tag             = try(l4_proxy_rules.value.rule_tag, "")
      session_persist      = try(l4_proxy_rules.value.session_persist, "off")
      session_persist_time = try(l4_proxy_rules.value.session_persist_time, 3600)
    }
  }
}