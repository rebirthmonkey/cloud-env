
# MySql Privilege Tencent Cloud MySQL Terraform Module

## Usage

```hcl
module "mysql_privilege" {
  source  = "terraform-tencentcloud-modules/mysql/tencentcloud//modules/mysql_instance"
  # version = "~> 1.0"    # you can specify the version of module here
  # insert the required variables here
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_mysql_privilege | Whether to create mysql privilege. | bool | true | no 
| account_name | Account name for mysql privilege. | string | "" | yes
| global | Global privileges. | list(string) | [] | yes
| mysql_id | Mysql instance id. | string | "" | yes
| account_host | Account host for mysql privilege, default is %. | string | "%" | no
| column | column privileges list. | list(map(any)) | [] | no
| database | database privileges list. | list(map(any)) | [] | no
| table | table privileges list. | list(map(any)) | [] | no


## Outputs

| Name | Description |
|------|-------------|
| mysql_privileg_id | The id of mysql privilege. |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
