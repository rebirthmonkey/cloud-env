resource "tencentcloud_mysql_backup_policy" "this" {
  count = var.create_backup_policy ? 1 : 0

  mysql_id         = var.mysql_id
  backup_model     = var.backup_model
  backup_time      = var.backup_time
  retention_period = var.retention_period
}

