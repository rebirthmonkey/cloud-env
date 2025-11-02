# MySql Instance Tencent Cloud MySQL Terraform Module

## Usage

```hcl
module "mysql_readonly" {
  source  = "terraform-tencentcloud-modules/mysql/tencentcloud//modules/mysql_instance"
  # version = "~> 1.0"    # you can specify the version of module here
  # insert the required variables here
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_mysql_readonly_instance | Whether to create mysql readonly instance. | bool | true | no 
| instance_id | The id of a mysql master instance. | string | "" | yes
| mem_size | Memory size (in MB). | string | 1000 | yes
| volume_size | Disk size (in GB). | string | 200 | yes
| auto_renew_flag | Auto renew flag. NOTES: Only supported prepaid instance. | string | 0 | no 
| charge_type | Pay type of instance, valid values are PREPAID, POSTPAID. Default is POSTPAID. | string | POSTPAID | no 
| cpu | CPU cores. | number | 2 | no
| device_type | Device type. | string | UNIVERSAL | no 
| force_delete | Indicate whether to delete instance directly or not. Default is false. If set true, the instance will be deleted instead of staying recycle bin. Note: only works for PREPAID instance. When the main mysql instance set true, this para of the readonly mysql instance will not take effect. | bool | false | no 
| intranet_port | Public access port, rang form 1024 to 65535 and default value is 3306. | string | 3306 | no 
| prepaid_period | Period of instance. NOTES: Only supported prepaid instance. | string | 1 | no 
| security_groups | Security groups to use. | list | [] | no 
| subnet_id | Private network ID. If vpc_id is set, this value is required. | string | "" | no 
| tags | Instance tags. | map | {} | no 
| vpc_id | ID of VPC, which can be modified once every 24 hours and can't be removed. | string | "" | no 
| zone | Zone information of readonly instance. | string | "" | no 


## Outputs

| Name | Description |
|------|-------------|
| mysql_readonly_instance_id | The readonly instance id of mysql. |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
