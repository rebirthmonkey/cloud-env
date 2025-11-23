locals {
  record_intranet_ip = var.create_private_dns_record ? tencentcloud_ckafka_instance.ckafka_instance.vip: var.record_intranet_ip
}

resource "tencentcloud_ckafka_instance" "ckafka_instance" {
  instance_name = var.instance_name
  charge_type = var.charge_type
  band_width = var.band_width
  disk_size = var.disk_size
  disk_type = var.disk_type
  period = var.period
  instance_type = var.instance_type
  kafka_version = var.kafka_version
  msg_retention_time = var.msg_retention_time
  multi_zone_flag = var.multi_zone_flag
  partition = var.partition
  public_network = var.public_network
  renew_flag = var.renew_flag
  subnet_id = var.subnet_id
  vpc_id = var.vpc_id
  zone_id = var.zone_id
  zone_ids = var.multi_zone_flag ? var.zone_ids : null

  config {
    auto_create_topic_enable = lookup(var.config, "auto_create_topic_enable", true)
    default_num_partitions = lookup(var.config, "default_num_partitions", 3)
    default_replication_factor = lookup(var.config, "default_replication_factor", 3)
  }

  dynamic_retention_config {
    bottom_retention = lookup(var.dynamic_retention_config, "bottom_retention", 0)
    disk_quota_percentage = lookup(var.dynamic_retention_config, "disk_quota_percentage", 0)
    enable = lookup(var.dynamic_retention_config, "enable", 1)
    step_forward_percentage = lookup(var.dynamic_retention_config, "step_forward_percentage", 0)
  }

  tag_set = var.tag_set
}

resource "tencentcloud_ckafka_topic" "ckafka_topic" {
  count                          = var.ckafka_topic == null ? 0 : 1
  instance_id                    = "${tencentcloud_ckafka_instance.ckafka_instance.id}"
  topic_name                     = lookup(var.ckafka_topic, "topic_name", "example")
  note                           = lookup(var.ckafka_topic, "note", "topic note")
  replica_num                    = lookup(var.ckafka_topic, "replica_num", 2)
  partition_num                  = lookup(var.ckafka_topic, "partition_num", 1)
  enable_white_list              = lookup(var.ckafka_topic, "enable_white_list", true)
  ip_white_list                  = lookup(var.ckafka_topic, "enable_white_list", true) ? lookup(var.ckafka_topic, "ip_white_list", ["ip1", "ip2"]) : null
  clean_up_policy                = lookup(var.ckafka_topic, "clean_up_policy", "delete")
  sync_replica_min_num           = lookup(var.ckafka_topic, "sync_replica_min_num", 1)
  unclean_leader_election_enable = lookup(var.ckafka_topic, "unclean_leader_election_enable", false)
  segment                        = lookup(var.ckafka_topic, "segment", 3600000)
  retention                      = lookup(var.ckafka_topic, "retention", 60000)
  max_message_bytes              = lookup(var.ckafka_topic, "max_message_bytes", 0)
}
resource "tencentcloud_ckafka_acl" "ckafka_acl" {
  count           = var.ckafka_acl == null ? 0 : 1
  instance_id     = "${tencentcloud_ckafka_instance.ckafka_instance.id}"
  resource_type   = lookup(var.ckafka_acl, "resource_type", "TOPIC")
  resource_name   = lookup(var.ckafka_acl, "resource_name", "topic-tf-test")
  operation_type  = lookup(var.ckafka_acl, "operation_type", "WRITE")
  permission_type = lookup(var.ckafka_acl, "permission_type", "ALLOW")
  host            = lookup(var.ckafka_acl, "host", "*")
  principal       = lookup(var.ckafka_acl, "principal", "*")
}
resource "tencentcloud_private_dns_record" "records" {
  for_each = var.records
  zone_id      = try(each.value.private_dns_id)
  record_type  = try(each.value.record_type, "A")
  record_value = local.record_intranet_ip
  sub_domain   = try(each.value.sub_domain, each.key)
  ttl          = try(each.value.ttl, 600)
  weight       = try(each.value.weight, 1)
  mx           = try(each.value.mx, null)  // 5, 10, 15, 20, 30, 40, 50.
}
