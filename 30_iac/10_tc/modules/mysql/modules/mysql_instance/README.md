# MySql Instance Tencent Cloud MySQL Terraform Module

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
| create_mysql_instance | Whether to create mysql instance. | bool | true | no 
| internet_service | Indicates whether to enable the access to an instance from public network: 0 - No, 1 - Yes. | string | 0 | no 
| auto_renew_flag | Auto renew flag. NOTES: Only supported prepaid instance. | string | 0 | no 
| mem_size | Memory size (in MB). | string | 1000 | yes
| cpu | CPU cores. | number | 2 | no
| device_type | Device type. | string | UNIVERSAL | no 
| availability_zone | Indicates which availability zone will be used. | string | "" | no 
| vpc_id | ID of VPC, which can be modified once every 24 hours and can't be removed. | string | "" | no 
| instance_name | The name of a mysql instance. | string |  | yes
| engine_version | The version number of the database engine to use. Supported versions include 5.5/5.6/5.7, and default is 5.7. | string | 5.7 | no 
| volume_size | Disk size (in GB). | string | 200 | yes
| intranet_port | Public access port, rang form 1024 to 65535 and default value is 3306. | string | 3306 | no 
| prepaid_period | Period of instance. NOTES: Only supported prepaid instance. | string | 1 | no 
| slave_sync_mode | Data replication mode. 0 - Async replication; 1 - Semisync replication; 2 - Strongsync replication. | string | 0 | no 
| backup_model | Backup method. Supported values include: 'physical' - physical backup. | string | physical | no 
| tags | Instance tags. | map | {} | no 
| root_password | Password of root account. This parameter can be specified when you purchase master instances, but it should be ignored when you purchase read-only instances or disaster recovery instances. | string | password | no 
| security_groups | Security groups to use. | list | [] | no 
| backup_time |  Instance backup time, in the format of "HH:mm-HH:mm". Time setting interval is four hours. Default to "02:00-06:00". The following value can be supported: 02:00-06:00, 06:00-10:00, 10:00-14:00, 14:00-18:00, 18:00-22:00, and 22:00-02:00. | string | 02:00-06:00 | no 
| first_slave_zone | Zone information about first slave instance. | string |  | no 
| retention_period |  Instance backup retention days. Valid values: [7-730]. And default value is 7. | number | 7 | no 
| project_id | Project ID, default value is 0. | string | 0 | no 
| parameters | List of parameters to use. | map | {} | no 
| force_delete | Indicate whether to delete instance directly or not. Default is false. If set true, the instance will be deleted instead of staying recycle bin. Note: only works for PREPAID instance. When the main mysql instance set true, this para of the readonly mysql instance will not take effect. | bool | false | no 
| slave_deploy_mode | Availability zone deployment method. Available values: 0 - Single availability zone; 1 - Multiple availability zones. | string | 0 | no 
| second_slave_zone | Zone information about second slave instance. | string | "" | no 
| subnet_id | Private network ID. If vpc_id is set, this value is required. | string | "" | no 
| charge_type | Pay type of instance, valid values are PREPAID, POSTPAID. Default is POSTPAID. | string | POSTPAID | no 


## Outputs

| Name | Description |
|------|-------------|
| db_instance_id | The instance id of mysql. |
| locked | Indicates whether the instance is locked. 0 - No; 1 - Yes. |
| gtid | Is GTID activated. |
| internet_host | Host for public access. |
| internet_port | Access port for public access. |
| intranet_ip | instance intranet IP. |
| status | Instance status. Available values: 0 - Creating; 1 - Running; 4 - Isolating; 5 - Isolated. |
| task_status | Indicates which kind of operations is being executed. |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
