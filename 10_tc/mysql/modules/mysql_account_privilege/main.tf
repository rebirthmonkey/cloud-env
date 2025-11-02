resource "tencentcloud_mysql_account_privilege" "this" {
  count = var.create_account_privilege ? 1 : 0

  account_name   = var.account_name
  database_names = var.database_names
  mysql_id       = var.mysql_id
  account_host   = var.account_host
  privileges     = var.privileges
}

