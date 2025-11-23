# Tencentcloud Auto Scaling Group Config

Module to create tencentcloud Auto Scaling Group Config

Auto Scaling Group Config:

Reference: https://www.tencentcloud.com/document/product/377/3579?lang=en&pg=

## Examples
- [as-config](../../examples/as-config) - A complete example of as-config

## usage
```hcl
module "as-config" {
  source = "../../modules/as-config"

  configuration_name = "test"

  tags               = { create: "terraform"}
  instance_name      = "as-instance"
  instance_types     = [ "S5.MEDIUM4" ]
  os_name            = "Ubuntu Server 22.04 LTS 64"
  enable_image_family = false
  image_id         = "img-487zeit5"
  //  image_family = "business-daily-update"

  enhanced_security_service = true
  enhanced_monitor_service = true
  enhanced_automation_tools_service = true

  system_disk_size   = 50
  system_disk_type = "CLOUD_BSSD"
  security_group_ids = [ "sg-0xia1k06" ]
}

```

To use image family, set

```hcl
  enable_image_family = true
  image_family        = "family-1"

```

To create an image family, use

```terraform

resource "tencentcloud_image" "image_snap" {
  image_family      = "family-1"
  image_name        = "family-1-2"
#  snapshot_ids      = ["snap-nbp3xy1d", "snap-nvzu3dmh"] // from snapshot
  instance_id = "ins-pvc72xzg"  // from a instance
  force_poweroff    = true
  image_description = "create image with snapshot"
}

```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.132 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.132 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_as_scaling_config.as_config](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/as_scaling_config) | resource |
| [tencentcloud_as_scaling_configs.as_config](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/data-sources/as_scaling_configs) | data source |
| [tencentcloud_images.this](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/data-sources/images) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocate_public_ip"></a> [allocate\_public\_ip](#input\_allocate\_public\_ip) | Associate a public IP address with an instance in a VPC or Classic. Boolean value, Default is false. | `bool` | `false` | no |
| <a name="input_as_config_id"></a> [as\_config\_id](#input\_as\_config\_id) | must specify an id if create\_as\_config is false | `string` | `""` | no |
| <a name="input_cam_role_name"></a> [cam\_role\_name](#input\_cam\_role\_name) | CAM role name authorized to access. | `string` | `null` | no |
| <a name="input_cdh_host_id"></a> [cdh\_host\_id](#input\_cdh\_host\_id) | Id of cdh instance. Note: it only works when instance\_charge\_type is set to CDHPAID. | `string` | `null` | no |
| <a name="input_cdh_instance_type"></a> [cdh\_instance\_type](#input\_cdh\_instance\_type) | Type of instance created on cdh, the value of this parameter is in the format of CDH\_XCXG based on the number of CPU cores and memory capacity. Note: it only works when instance\_charge\_type is set to CDHPAID. | `string` | `null` | no |
| <a name="input_configuration_name"></a> [configuration\_name](#input\_configuration\_name) | Name of a launch configuration. | `string` | `""` | no |
| <a name="input_create"></a> [create](#input\_create) | create AS config or not. | `bool` | `true` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | List of data\_disks to create. type, size supported | `any` | `[]` | no |
| <a name="input_delete_with_instance"></a> [delete\_with\_instance](#input\_delete\_with\_instance) | ForceNew. Decides whether the disk is deleted with instance(only applied to CLOUD\_BASIC, CLOUD\_SSD and CLOUD\_PREMIUM disk with POSTPAID\_BY\_HOUR instance), default is true. | `bool` | `true` | no |
| <a name="input_enable_image_family"></a> [enable\_image\_family](#input\_enable\_image\_family) | as config use image family | `bool` | `false` | no |
| <a name="input_enhanced_automation_tools_service"></a> [enhanced\_automation\_tools\_service](#input\_enhanced\_automation\_tools\_service) | To specify whether to enable cloud automation tools service. | `bool` | `true` | no |
| <a name="input_enhanced_monitor_service"></a> [enhanced\_monitor\_service](#input\_enhanced\_monitor\_service) | enable monitor service | `bool` | `true` | no |
| <a name="input_enhanced_security_service"></a> [enhanced\_security\_service](#input\_enhanced\_security\_service) | enable security service | `bool` | `true` | no |
| <a name="input_eni_ids"></a> [eni\_ids](#input\_eni\_ids) | A list of eni\_id to bind with the instance. see resource tencentcloud\_eni. | `list(string)` | `[]` | no |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | the name of host to create. | `string` | `"host"` | no |
| <a name="input_host_name_style"></a> [host\_name\_style](#input\_host\_name\_style) | The style of the host name of the cloud server, the value range includes ORIGINAL and UNIQUE, the default is ORIGINAL; ORIGINAL, the AS directly passes the HostName filled in the input parameter to the CVM, and the CVM may append a sequence to the HostName number, the HostName of the instance in the scaling group will conflict; UNIQUE, the HostName filled in as a parameter is equivalent to the host name prefix, AS and CVM will expand it, and the HostName of the instance in the scaling group can be guaranteed to be unique. | `string` | `"UNIQUE"` | no |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | image Family Name. Either Image ID or Image Family Name must be provided, but not both. Only effects when enable\_image\_family is true | `string` | `null` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The image to use for the instance. Changing image\_id will cause the instance reset. | `string` | `null` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | help to find image when image id is not set, conflict with os\_name | `string` | `null` | no |
| <a name="input_image_type"></a> [image\_type](#input\_image\_type) | help to find image when image id is not set | `list(string)` | <pre>[<br/>  "PUBLIC_IMAGE"<br/>]</pre> | no |
| <a name="input_instance_charge_type"></a> [instance\_charge\_type](#input\_instance\_charge\_type) | he charge type of instance. Valid values are PREPAID, POSTPAID\_BY\_HOUR, SPOTPAID and CDHPAID. The default is POSTPAID\_BY\_HOUR.TencentCloud International only supports POSTPAID\_BY\_HOUR and CDHPAID.  CDHPAID instance must set cdh\_instance\_type and cdh\_host\_id. | `string` | `"POSTPAID_BY_HOUR"` | no |
| <a name="input_instance_charge_type_prepaid_period"></a> [instance\_charge\_type\_prepaid\_period](#input\_instance\_charge\_type\_prepaid\_period) | The tenancy (time unit is month) of the prepaid instance, NOTE: it only works when instance\_charge\_type is set to PREPAID. Valid values are 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36. | `number` | `null` | no |
| <a name="input_instance_charge_type_prepaid_renew_flag"></a> [instance\_charge\_type\_prepaid\_renew\_flag](#input\_instance\_charge\_type\_prepaid\_renew\_flag) | Auto renewal flag. Valid values: NOTIFY\_AND\_AUTO\_RENEW: notify upon expiration and renew automatically, NOTIFY\_AND\_MANUAL\_RENEW: notify upon expiration but do not renew automatically, DISABLE\_NOTIFY\_AND\_MANUAL\_RENEW: neither notify upon expiration nor renew automatically. Default value: NOTIFY\_AND\_MANUAL\_RENEW. If this parameter is specified as NOTIFY\_AND\_AUTO\_RENEW, the instance will be automatically renewed on a monthly basis if the account balance is sufficient. NOTE: it only works when instance\_charge\_type is set to PREPAID. | `string` | `null` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | the name of instance to create. | `string` | `"instance"` | no |
| <a name="input_instance_name_style"></a> [instance\_name\_style](#input\_instance\_name\_style) | Type of CVM instance name. Valid values: ORIGINAL and UNIQUE. Default is ORIGINAL. | `string` | `"UNIQUE"` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Specified types of CVM instances. | `list(string)` | <pre>[<br/>  "S5.MEDIUM2"<br/>]</pre> | no |
| <a name="input_internet_charge_type"></a> [internet\_charge\_type](#input\_internet\_charge\_type) | Charge types for network traffic. Valid values: BANDWIDTH\_PREPAID, TRAFFIC\_POSTPAID\_BY\_HOUR and BANDWIDTH\_PACKAGE. | `string` | `"TRAFFIC_POSTPAID_BY_HOUR"` | no |
| <a name="input_internet_max_bandwidth_out"></a> [internet\_max\_bandwidth\_out](#input\_internet\_max\_bandwidth\_out) | Maximum outgoing bandwidth to the public network, measured in Mbps (Mega bits per second). This value does not need to be set when allocate\_public\_ip is false. | `number` | `10` | no |
| <a name="input_key_ids"></a> [key\_ids](#input\_key\_ids) | Key ids of the Key Pair to use for the instance; which can be managed using the `tencentcloud_key_pair` resource | `list(string)` | `null` | no |
| <a name="input_os_name"></a> [os\_name](#input\_os\_name) | help to find image when image id is not set, conflict with image\_name | `string` | `null` | no |
| <a name="input_password"></a> [password](#input\_password) | Login password of the instance. For Linux instances, the password must include 8-30 characters, and contain at least two of the following character sets: [a-z], [A-Z], [0-9] and [()`~!@#$%^&*-+=` | `string` | `null` | no |
| <a name="input_placement_group_id"></a> [placement\_group\_id](#input\_placement\_group\_id) | The Placement Group Id to start the instance in, see tencentcloud\_placement\_group. | `string` | `""` | no |
| <a name="input_placement_group_name"></a> [placement\_group\_name](#input\_placement\_group\_name) | The Placement group name to start the instance in, see tencentcloud\_placement\_group. will ignore if placement\_group\_id passed. | `string` | `""` | no |
| <a name="input_placement_group_type"></a> [placement\_group\_type](#input\_placement\_group\_type) | The Placement Group type to start the instance in, see tencentcloud\_placement\_group. will ignore if placement\_group\_id passed. | `string` | `"HOST"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | project id. | `number` | `0` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of orderly security group IDs to associate with. | `list(string)` | `null` | no |
| <a name="input_spot_instance_type"></a> [spot\_instance\_type](#input\_spot\_instance\_type) | Type of spot instance, only support one-time now. Note: it only works when instance\_charge\_type is set to SPOTPAID | `string` | `"one-time"` | no |
| <a name="input_spot_max_price"></a> [spot\_max\_price](#input\_spot\_max\_price) | Max price of a spot instance, is the format of decimal string, for example "0.50". Note: it only works when instance\_charge\_type is set to SPOTPAID. | `string` | `"0.50"` | no |
| <a name="input_system_disk_size"></a> [system\_disk\_size](#input\_system\_disk\_size) | Size of the system disk. unit is GB, Default is 50GB. If modified, the instance may force stop. | `number` | `50` | no |
| <a name="input_system_disk_type"></a> [system\_disk\_type](#input\_system\_disk\_type) | System disk type. For more information on limits of system disk types, see Storage Overview. Valid values: LOCAL\_BASIC: local disk, LOCAL\_SSD: local SSD disk, CLOUD\_SSD: SSD, CLOUD\_PREMIUM: Premium Cloud | `string` | `"CLOUD_PREMIUM"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | Can be used instead of user\_data\_raw to pass base64-encoded binary data directly. Use this instead of user\_data\_raw whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption. | `string` | `null` | no |
| <a name="input_user_data_raw"></a> [user\_data\_raw](#input\_user\_data\_raw) | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user\_data\_base64 instead. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_as_config_id"></a> [as\_config\_id](#output\_as\_config\_id) | ID of AS config |
| <a name="output_as_config_name"></a> [as\_config\_name](#output\_as\_config\_name) | n/a |
| <a name="output_as_config_version"></a> [as\_config\_version](#output\_as\_config\_version) | n/a |
