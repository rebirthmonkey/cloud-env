# TencentCloud MySQL Module for Terraform

## terraform-tencentcloud-mysql

A terraform module used to create TencentCloud MySQL instance, readonly instances and database privileges.

The following resources are included.

* [MySQL](https://www.terraform.io/docs/providers/tencentcloud/r/mysql_instance.html)
* [MySQL Account](https://www.terraform.io/docs/providers/tencentcloud/r/mysql_account.html)
* [MySQL Account Privilege](https://www.terraform.io/docs/providers/tencentcloud/r/mysql_account_privilege.html)
* [MySQL Backup Policy](https://www.terraform.io/docs/providers/tencentcloud/r/mysql_backup_policy.html)
* [MySQL Privilege](https://www.terraform.io/docs/providers/tencentcloud/r/mysql_privilege.html)
* [MySQL Readonly Instance](https://www.terraform.io/docs/providers/tencentcloud/r/mysql_readonly_instance.html)

## Usage

For new instance

```hcl
module "mysql" {
    source = "terraform-tencentcloud-modules/mysql/tencentcloud"

    ###############
    # MySQL Instance
    ###############

    instance_name = "5.7"
    mem_size = 1000
    volume_size = 200
    root_password = "root_passwd1"
    availability_zone = "ap-guangzhou-1"
    security_groups = ["sg-nltpbqg1"]
    vpc_id = "vpc-h70b6b49"
    subnet_id = "subnet-pyio7yog"
    first_slave_zone = "ap-guangzhou-1"

    tags = {
        Env = "dev"
    }

    ###############
    # MySQL Account
    ###############

    account = [
      {
        account_name = "test"
        account_password = "1234567"
        account_description = "test account for module"
        account_host = "10.0.0.1"
      }
    ]

    ###############
    # MySQL Account Privilege
    # It has been deprecated and replaced by tencentcloud_mysql_privilege.
    ###############

    create_account_privilege = true
    account_privilege = [
      {
        account_name = "test"
        database_names = ["test_db"]
        account_host = "10.0.0.1"
        privileges = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP", "TRIGGER"]
      }
    ]

    ###############
    # MySQL Backup Policy
    ###############

    backup_model = "physical"
    backup_time = "02:00-06:00"
    retention_period = 7

    ###############
    # MySQL Privilege
    ###############
    
    create_mysql_privilege = true
    mysql_privilege = [
      {
        account_name = "test"
        gloabl = ["ALTER", "CREATE", "DELETE", "DROP", "INDEX"]
        account_host = "10.0.0.1"
        column = [
          {
            column_name = "host" 
            database_name = "mysql"
            privileges = ["SELECT", "INSERT", "UPDATE", "REFERENCES"]
            table_name = "test_table"
          }
        ]
        databases = [
          {
            database_name = "mysql"
            privileges = ["SELECT"]
          }
        ]
        table = [
          {
            database_name = "mysql"
            privileges = ["SELECT", "INSERT", "UPDATE"]
            table_name = "test_table"
          }
        ]
      }
    ]

    ###############
    # MySQL Readonly Instance
    ###############

    create_readonly_instance = true
    readonly_instances = [
      {
        instance_name = "5.7-readonly1"
        mem_size = 500
        volume_size = 100
        auto_renew_flag = 1
        charge_type = "PREPAID"
        prepaid_period = 1
        security_groups = ["sg-nltpbqg1"]
        vpc_id = "vpc-h70b6b49"
        subnet_id = "subnet-pyio7yog"
        tags = {
          Env = "readonly"
        }
        zone = "ap-guangzhou-3"
      }
    ]
}
```

For existing instance 

```hcl
module "mysql" {
    source = "terraform-tencentcloud-modules/mysql/tencentcloud"
    
    ###############
    # MySQL Instance
    ###############

    instance_id = "im-123567984"

    ###############
    # MySQL Account
    ###############

    account = [
      {
        account_name = "test"
        account_password = "1234567"
        account_description = "test account for module"
        account_host = "10.0.0.1"
      }
    ]

    ###############
    # MySQL Account Privilege
    ###############

    create_account_privilege = true
    account_privilege = [
      {
        account_name = "test"
        database_names = ["test_db"]
        account_host = "10.0.0.1"
        privileges = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP", "TRIGGER"]
      }
    ]

    ###############
    # MySQL Backup Policy
    ###############

    backup_model = "physical"
    backup_time = "02:00-06:00"
    retention_period = 7

    ###############
    # MySQL Privilege
    ###############
    
    create_mysql_privilege = true
    mysql_privilege = [
      {
        account_name = ""
        gloabl = ""
        account_host = ""
        column = [
          {
            column_name = "host" 
            database_name = "mysql"
            privileges = ["SELECT", "INSERT", "UPDATE", "REFERENCES"]
            table_name = "test_table"
          }
        ]
        databases = [
          {
            database_name = "mysql"
            privileges = ["SELECT"]
          }
        ]
        table = [
          {
            database_name = "mysql"
            privileges = ["SELECT", "INSERT", "UPDATE"]
            table_name = "test_table"
          }
        ]
      }
    ]

    ###############
    # MySQL Readonly Instance
    ###############

    create_readonly_instance = true
    readonly_instances = [
      {
        instance_name = "5.7-readonly1"
        mem_size = 500
        volume_size = 100
        auto_renew_flag = 1
        charge_type = "PREPAID"
        prepaid_period = 1
        security_groups = ["sg-nltpbqg1"]
        vpc_id = "vpc-h70b6b49"
        subnet_id = "subnet-pyio7yog"
        tags = {
          Env = "readonly"
        }
        zone = "ap-guangzhou-3"
      }
    ]

}
```

## Conditional Creation
```hcl
module "mysql" {
    source = "terraform-tencentcloud-modules/mysql/tencentcloud"

    # Disable creation of MySQL instance(s)
    create_mysql_instance = false

    # Disable creation of MySQL account
    create_mysql_account = false

    # Disable creation of MySQL backup policy
    create_backup_policy = false

    # Enable creation of MySQL account privilege
    create_account_privilege = true
    
    # Enable creation of MySQL privilege
    create_mysql_privilege = true

    # Enable creation of MySQL readonly instance
    create_mysql_readonly_instance = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_mysql_instance | Whether to create mysql instance. | bool | true | no 
| create_mysql_account | Whether to create mysql account. | bool | true | no 
| create_backup_policy | Whether to create mysql backup policy. | bool | true | no 
| create_account_privilege | Whether to create mysql account privilege. | bool | false | no 
| create_mysql_privilege | Whether to create mysql privilege. | bool | false | no 
| create_mysql_readonly_instance | Whether to create mysql readonly_instance. | bool | false | no 
| internet_service | Indicates whether to enable the access to an instance from public network: 0 - No, 1 - Yes. | string | 0 | no 
| auto_renew_flag | Auto renew flag. NOTES: Only supported prepaid instance. | string | 0 | no 
| account_privilege | Multiple account privilege configuration instances.Every element of the list contains a tencentcloud_mysql_account_privilege configuration object.See https://www.terraform.io/docs/providers/tencentcloud/r/mysql_account_privilege.html for configuration guide. | list | [] | no 
| mem_size | Memory size (in MB). | string | 1000 | no 
| cpu | CPU cores. | number | 2 | no 
| device_type | Device type. | string | UNIVERSAL | no 
| availability_zone | Indicates which availability zone will be used. | string | "" | no 
| vpc_id | ID of VPC, which can be modified once every 24 hours and can't be removed. | string | "" | no 
| instance_name | The name of a mysql instance. | string |  | no 
| engine_version | The version number of the database engine to use. Supported versions include 5.5/5.6/5.7, and default is 5.7. | string | 5.7 | no 
| volume_size | Disk size (in GB). | string | 200 | no 
| intranet_port | Public access port, rang form 1024 to 65535 and default value is 3306. | string | 3306 | no 
| prepaid_period | Period of instance. NOTES: Only supported prepaid instance. | string | 1 | no 
| slave_sync_mode | Data replication mode. 0 - Async replication; 1 - Semisync replication; 2 - Strongsync replication. | string | 0 | no 
| backup_model | Backup method. Supported values include: 'physical' - physical backup. | string | physical | no 
| tags | Instance tags. | map | {} | no 
| root_password | Password of root account. This parameter can be specified when you purchase master instances, but it should be ignored when you purchase read-only instances or disaster recovery instances. | string | password | no 
| security_groups | Security groups to use. | list | [] | no 
| backup_time |  Instance backup time, in the format of "HH:mm-HH:mm". Time setting interval is four hours. Default to "02:00-06:00". The following value can be supported: 02:00-06:00, 06:00-10:00, 10:00-14:00, 14:00-18:00, 18:00-22:00, and 22:00-02:00. | string | 02:00-06:00 | no 
| region | TencentCloud region to launch resources. | string |  | no 
| first_slave_zone | Zone information about first slave instance. | string |  | no 
| retention_period |  Instance backup retention days. Valid values: [7-730]. And default value is 7. | number | 7 | no 
| project_id | Project ID, default value is 0. | string | 0 | no 
| parameters | List of parameters to use. | map | {} | no 
| force_delete | Indicate whether to delete instance directly or not. Default is false. If set true, the instance will be deleted instead of staying recycle bin. Note: only works for PREPAID instance. When the main mysql instance set true, this para of the readonly mysql instance will not take effect. | bool | false | no 
| slave_deploy_mode | Availability zone deployment method. Available values: 0 - Single availability zone; 1 - Multiple availability zones. | string | 0 | no 
| second_slave_zone | Zone information about second slave instance. | string | "" | no 
| account | Multiple account instances.Every element of the list contains a tencentcloud_mysql_account configuration object.See https://www.terraform.io/docs/providers/tencentcloud/r/mysql_account.html for configuration guide. | list(map(string)) | [] | no 
| mysql_privilege | Multiple privilege configuration instances.Every element of the list contains a tencentcloud_mysql_privilege configuration object.See https://www.terraform.io/docs/providers/tencentcloud/r/mysql_privilege.html for configuration guide. | list | [] | no 
| instance_id | The id of a mysql instance. | string | "" | no 
| subnet_id | Private network ID. If vpc_id is set, this value is required. | string | "" | no 
| charge_type | Pay type of instance, valid values are PREPAID, POSTPAID. Default is POSTPAID. | string | POSTPAID | no 
| readonly_instances | Multiple readonly instances.Every element of the list contains a tencentcloud_mysql_readonly_instance configuration object.See https://www.terraform.io/docs/providers/tencentcloud/r/mysql_readonly_instance.html for configuration guide. | list | [] | no 
| readonly_instance_zone | Zone information of readonly instance. | string | "" | no 


## Outputs

| Name | Description |
|------|-------------|
| db_instance_id | The instance id of mysql. |
| locked | Indicates whether the instance is locked. 0 - No; 1 - Yes. |
| backup_policy_id | The id of backup policy. |
| binlog_period | Retention period for binlog in days. |
| mysql_privilege_ids | The id list of created resource tencentcloud_mysql_privilege. |
| mysql_readonly_instance_ids | The id list of created resource tencentcloud_mysql_readonly_instance |
| account_ids | Account id list which returned by the account resource created.If not created,returns `[]`. |
| account_privilege_ids | The id list of created resource tencentcloud_mysql_account_privilege. |
| gtid | Is GTID activated. |
| internet_host | Host for public access. |
| internet_port | Access port for public access. |
| intranet_ip | instance intranet IP. |
| status | Instance status. Available values: 0 - Creating; 1 - Running; 4 - Isolating; 5 - Isolated. |
| task_status | Indicates which kind of operations is being executed. |


## Authors

Created and maintained by [TencentCloud](https://github.com/tencentcloudstack/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
