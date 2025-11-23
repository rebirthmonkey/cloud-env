# MySql Account Tencent Cloud MySQL Terraform Module

## Usage

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
| create_mysql_account | Whether to create mysql account. | bool | true | no 
| mysql_id | Mysql instance id. | string | "" | yes
| name | Account name will be created. | string | "" | yes
| password | Operation password of the account. | string | "" | yes
| description | Database description. | string | "" | no
| host | Account host, default is %. | string | "%" | no



## Outputs

| Name | Description |
|------|-------------|
| account_id | The id of mysql account. |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
