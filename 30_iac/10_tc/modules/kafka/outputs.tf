
output ckafka_vpc_id {
  value       = var.vpc_id
  description = "Vpc id."
}
output ckafka_subnet_id {
  value       = var.subnet_id
  description = "Subnet id."
}
output ckafka_instance_id {
  value       = tencentcloud_ckafka_instance.ckafka_instance.id
  description = "Ckafka instance id."
}
output ckafka_instance_name {
  value       = var.instance_name
  description = "Ckafka instance name."
}
output ckafka_zone_id {
  value       = var.zone_id
  description = "Ckafka available zone id."
}
output ckafka_instance_vip {
  value       = tencentcloud_ckafka_instance.ckafka_instance.vip
  description = "Vip of instance."
}
output ckafka_instance_vport {
  value       = tencentcloud_ckafka_instance.ckafka_instance.vport
  description = "Type of instance."
}
output ckafka_acl_id {
  value       = var.ckafka_acl == null ? "" : tencentcloud_ckafka_acl.ckafka_acl[0].id
  description = "Ckafka acl id"
}
output ckafka_topic_id {
  value       = var.ckafka_topic == null ? "" : tencentcloud_ckafka_topic.ckafka_topic[0].id
  description = "Ckafka topic id."
}
output ckafka_topic_create_time {
  value       = var.ckafka_topic == null ? "" : tencentcloud_ckafka_topic.ckafka_topic[0].create_time
  description = "Create time of the CKafka topic."
}
output ckafka_topic_forward_cos_bucket {
  value       = var.ckafka_topic == null ? "" : tencentcloud_ckafka_topic.ckafka_topic[0].forward_cos_bucket
  description = "Data backup cos bucket: the bucket address that is dumped to cos."
}
output ckafka_topic_forward_interval {
  value       = var.ckafka_topic == null ? "" : tencentcloud_ckafka_topic.ckafka_topic[0].forward_interval
  description = "Periodic frequency of data backup to cos."
}
output ckafka_topic_forward_status {
  value       = var.ckafka_topic == null ? "" : tencentcloud_ckafka_topic.ckafka_topic[0].forward_status
  description = "Data backup cos status. Valid values: 0, 1. 1: do not open data backup, 0: open data backup."
}
output ckafka_topic_message_storage_location {
  value       = var.ckafka_topic == null ? "" : tencentcloud_ckafka_topic.ckafka_topic[0].message_storage_location
  description = "Message storage location."
}
output ckafka_topic_segment_bytes {
  value       = var.ckafka_topic == null ? "" : tencentcloud_ckafka_topic.ckafka_topic[0].segment_bytes
  description = "Number of bytes rolled by shard."
}
