resource "tencentcloud_mysql_privilege" "this" {
  count = var.create_mysql_privilege ? 1 : 0

  account_name = var.account_name
  global = var.global
  mysql_id = var.mysql_id
  account_host = var.account_host

  dynamic "column" {
    for_each = var.column
    content {
      column_name   = column.value["column_name"]
      table_name    = column.value["table_name"]
      database_name = column.value["database_name"]
      privileges    = column.value["privileges"]
    }
  }

  dynamic "database" {
    for_each = var.database
    content {
      database_name = database.value["database_name"]
      privileges    = database.value["privileges"]
    }
  }

  dynamic "table" {
    for_each = var.table
    content {
      database_name = table.value["database_name"]
      privileges    = table.value["privileges"]
      table_name    = table.value["table_name"]
    }
  }
}
