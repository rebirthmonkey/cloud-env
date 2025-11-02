# MySql Account Privilege Tencent Cloud MySQL Terraform Module
## Usage

### It has been deprecated and replaced by tencentcloud_mysql_privilege.
```hcl
module "mysql" {
  source  = "terraform-tencentcloud-modules/mysql/tencentcloud//modules/mysql_instance"
  # version = "~> 1.0"    # you can specify the version of module here
  # insert the required variables here
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_account_privilege | Whether to create mysql account privilege. | bool | true | no 
| account_name | Account name. | string | "" | yes
| database_names | List of specified database name. | list(string) | [""] | yes
| mysql_id | Mysql instance id. | string | "" | yes
| account_host | Account host, default is %. | string | "%" | no
| privileges | List of database permission. | list(string) | [""] | no

## Outputs

| Name | Description |
|------|-------------|
| account_privilege_id | The id of mysql account privilege. |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
