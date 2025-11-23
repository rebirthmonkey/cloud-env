# Tencentcloud Auto Scaling Group

Module to create tencentcloud Auto Scaling Group

Auto Scaling Group:

Reference: https://www.tencentcloud.com/zh/document/product/377

## Examples
- [as-group](../../examples/as-group) - A complete example of as-group

## About the auto refresh trigger:

1. enable auto refresh trigger

Note: Trigger will be triggered the first time you set trigger_refresh to true, no matter the config change or not

```hcl
  trigger_refresh             = true
  rolling_update_batch_number = 2 # this should always less than or equal to running instance number
```

2. trigger refresh

After the trigger_refresh enabled, any change of config id or config version will trigger auto refresh

Mechanism:

```hcl

# triggered by this key

as_config_trigger_key = format("%s_%s", var.as_config_id, data.tencentcloud_as_scaling_configs.as_config.configuration_list[0].version_number)

```

3. Setup a timeout for auto refresh, it is by default 20 minutes

```hcl
  refresh_timeout = "5m"
```


## usage
```hcl
module "as-group" {
  source = "../../modules/as-group"

  tags = { create : "terraform" }

  scaling_group_name = "ag-test"

  as_config_id      = "asc-8n5nxac7"
  as_config_version = 1

  vpc_id              = "vpc-fkbtycmtno"
  subnet_ids = ["subnet-qaf6qdts", "subnet-ch8ibgg8"]
  as_max_size         = 5
  as_min_size = 0
  // If you set trigger_refresh to true, make sure as_desired_capacity > 0, because the first trigger will fail if no instance in the as group
  as_desired_capacity = 1

  replace_load_balancer_unhealthy = false
  enable_auto_scaling             = true

  trigger_refresh = true
  refresh_timeout = "5m"
  rolling_update_batch_number = 1 # this should always less than or equal to running instance number
  rolling_update_max_surge = 1 #

  hooks = {
    startup = {
      lifecycle_hook_name  = "startup"
      lifecycle_transition = "INSTANCE_LAUNCHING"
      lifecycle_command = {
        command_id = "cmd-9punekiv"
      }
      lifecycle_transition_type = "EXTENSION"
    }
    shutdown = {
      lifecycle_hook_name  = "shutdown"
      lifecycle_transition = "INSTANCE_TERMINATING"
      lifecycle_command = {
        command_id = "cmd-4oplyrwp"
      }
      lifecycle_transition_type = "NORMAL"
    }
  }

}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.144 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.144 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.refresh_trigger](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tencentcloud_as_lifecycle_hook.hooks](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/as_lifecycle_hook) | resource |
| [tencentcloud_as_scaling_group.as_group](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/as_scaling_group) | resource |
| [tencentcloud_as_scaling_group_status.scaling_group_status](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/as_scaling_group_status) | resource |
| [tencentcloud_as_scaling_policy.as_policies](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/as_scaling_policy) | resource |
| [tencentcloud_as_start_instance_refresh.config_changes](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/as_start_instance_refresh) | resource |
| [tencentcloud_as_scaling_configs.as_config](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/data-sources/as_scaling_configs) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_as_config_id"></a> [as\_config\_id](#input\_as\_config\_id) | auto scaling config id | `string` | `""` | no |
| <a name="input_as_config_version"></a> [as\_config\_version](#input\_as\_config\_version) | auto scaling config version number | `string` | `""` | no |
| <a name="input_as_desired_capacity"></a> [as\_desired\_capacity](#input\_as\_desired\_capacity) | Desired volume of CVM instances, which is between max\_size and min\_size. | `number` | `0` | no |
| <a name="input_as_max_size"></a> [as\_max\_size](#input\_as\_max\_size) | Maximum number of CVM instances. Valid value ranges: (0~2000). | `number` | `3` | no |
| <a name="input_as_min_size"></a> [as\_min\_size](#input\_as\_min\_size) | Minimum number of CVM instances. Valid value ranges: (0~2000). | `number` | `1` | no |
| <a name="input_as_policies"></a> [as\_policies](#input\_as\_policies) | AS policies. | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | create AS group or not. | `bool` | `true` | no |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling) | If enable auto scaling group. | `bool` | `true` | no |
| <a name="input_forward_balancers"></a> [forward\_balancers](#input\_forward\_balancers) | List of application load balancers. | `any` | `[]` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | Health check type of instances in a scaling group. | `string` | `null` | no |
| <a name="input_hooks"></a> [hooks](#input\_hooks) | lifecycle hooks. | `any` | `{}` | no |
| <a name="input_host_name_style"></a> [host\_name\_style](#input\_host\_name\_style) | The style of the host name of the cloud server, the value range includes ORIGINAL and UNIQUE, the default is ORIGINAL; ORIGINAL, the AS directly passes the HostName filled in the input parameter to the CVM, and the CVM may append a sequence to the HostName number, the HostName of the instance in the scaling group will conflict; UNIQUE, the HostName filled in as a parameter is equivalent to the host name prefix, AS and CVM will expand it, and the HostName of the instance in the scaling group can be guaranteed to be unique. | `string` | `"UNIQUE"` | no |
| <a name="input_internet_charge_type"></a> [internet\_charge\_type](#input\_internet\_charge\_type) | Charge types for network traffic. Valid values: BANDWIDTH\_PREPAID, TRAFFIC\_POSTPAID\_BY\_HOUR and BANDWIDTH\_PACKAGE. | `string` | `"TRAFFIC_POSTPAID_BY_HOUR"` | no |
| <a name="input_lb_health_check_grace_period"></a> [lb\_health\_check\_grace\_period](#input\_lb\_health\_check\_grace\_period) | Grace period of the CLB health check during which the IN\_SERVICE instances added will not be marked as CLB\_UNHEALTHY.Valid range: 0-7200, in seconds. Default value: 0. | `number` | `0` | no |
| <a name="input_multi_zone_subnet_policy"></a> [multi\_zone\_subnet\_policy](#input\_multi\_zone\_subnet\_policy) | Multi zone or subnet strategy, Valid values: PRIORITY and EQUALITY. | `string` | `"EQUALITY"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | project id. | `number` | `0` | no |
| <a name="input_refresh_mode"></a> [refresh\_mode](#input\_refresh\_mode) | Refresh mode: ROLLING\_UPDATE\_RESET or ROLLING\_UPDATE\_REPLACE | `string` | `"ROLLING_UPDATE_RESET"` | no |
| <a name="input_refresh_timeout"></a> [refresh\_timeout](#input\_refresh\_timeout) | timeout for the as group refresh | `string` | `"20m"` | no |
| <a name="input_replace_load_balancer_unhealthy"></a> [replace\_load\_balancer\_unhealthy](#input\_replace\_load\_balancer\_unhealthy) | Enable unhealthy instance replacement. If set to true, AS will replace instances that are found unhealthy in the CLB health check. | `bool` | `true` | no |
| <a name="input_replace_monitor_unhealthy"></a> [replace\_monitor\_unhealthy](#input\_replace\_monitor\_unhealthy) | Enables unhealthy instance replacement. If set to true, AS will replace instances that are flagged as unhealthy by Cloud Monitor. | `bool` | `false` | no |
| <a name="input_retry_policy"></a> [retry\_policy](#input\_retry\_policy) | Available values for retry policies. Valid values: IMMEDIATE\_RETRY and INCREMENTAL\_INTERVALS. | `string` | `"IMMEDIATE_RETRY"` | no |
| <a name="input_rolling_update_batch_number"></a> [rolling\_update\_batch\_number](#input\_rolling\_update\_batch\_number) | Batch quantity. The batch quantity should be a positive integer greater than 0, but cannot exceed the total number of instances pending refresh. | `number` | `1` | no |
| <a name="input_rolling_update_max_surge"></a> [rolling\_update\_max\_surge](#input\_rolling\_update\_max\_surge) | Maximum Extra Quantity. After setting this parameter, a batch of pay-as-you-go extra instances will be created according to the launch configuration before the rolling update starts, and the extra instances will be destroyed after the rolling update is completed. | `number` | `null` | no |
| <a name="input_scaling_group_name"></a> [scaling\_group\_name](#input\_scaling\_group\_name) | Name of a scaling group | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | ID list of subnet, and for VPC it is required. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags of a scaling group. | `map(string)` | `{}` | no |
| <a name="input_termination_policies"></a> [termination\_policies](#input\_termination\_policies) | Available values for termination policies. Valid values: OLDEST\_INSTANCE and NEWEST\_INSTANCE. | `list(string)` | <pre>[<br/>  "OLDEST_INSTANCE"<br/>]</pre> | no |
| <a name="input_trigger_refresh"></a> [trigger\_refresh](#input\_trigger\_refresh) | if trigger refresh instances when config version changed | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of VPC network. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_as_group_id"></a> [as\_group\_id](#output\_as\_group\_id) | ID of AS group. |
