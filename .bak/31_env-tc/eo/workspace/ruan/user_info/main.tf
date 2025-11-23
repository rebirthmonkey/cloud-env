data "tencentcloud_user_info" "this" {}

output "app_id" {
  value = data.tencentcloud_user_info.this.app_id
}

#output "user_info" {
#  value = data.tencentcloud_user_info.this
#}

output "user_info" {
  value = {
    app_id = data.tencentcloud_user_info.this.app_id
#    name = data.tencentcloud_user_info.this.name
    owner_uin = data.tencentcloud_user_info.this.owner_uin
#    uin = data.tencentcloud_user_info.this.uin
  }

}


terraform {
  required_version = ">= 0.12"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">=1.81.2"
    }
  }
}