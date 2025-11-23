# MySql Backup Policy Tencent Cloud MySQL Terraform Module

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
| create_backup_policy | Whether to create mysql backup policy. | bool | true | no 


## Outputs

| Name | Description |
|------|-------------|
| backup_policy_id | The id of mysql backup policy. |
| binlog_period | Retention period for binlog in days. |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
