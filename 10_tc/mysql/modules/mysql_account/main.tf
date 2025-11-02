resource "tencentcloud_mysql_account" "this" {
  count = var.create_mysql_account ? 1 : 0

  mysql_id    = var.mysql_id
  name        = var.name
  password    = var.password
  description = var.description
  host        = var.host
}
