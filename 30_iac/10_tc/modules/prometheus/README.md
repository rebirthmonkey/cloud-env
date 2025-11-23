# terraform-tencentcloud-prometheus
Terraform module which creates Prometheus resources on TencentCloud

## Usage

```hcl
module "prometheus_instance" {
  source = "terraform-tencentcloud-modules/prometheus/tencentcloud"

  prometheus_instance_name = "prometheus_for_test"
  vpc_id                   = "vpc-xxxxx"
  subnet_id                = "subnet-xxxxx"
  data_retention_time      = 30
  availability_zone        = "ap-guangzhou-3"
  prometheus_tags          =  {
    "createby" = "terraform"
  }
}
```

## Examples

- [Simple](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-prometheus/tree/master/examples/simple)
- [Exist Prometheus](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-prometheus/tree/master/examples/exist-prometheus)
- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-prometheus/tree/master/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >=1.81.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >=1.81.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_monitor_tmp_instance.tmp_instance](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/monitor_tmp_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability Zone. | `string` | `"ap-guangzhou-3"` | no |
| <a name="input_create_prometheus_instance"></a> [create\_prometheus\_instance](#input\_create\_prometheus\_instance) | Controls if Prometheus instance should be created (it affects almost all resources). | `bool` | `true` | no |
| <a name="input_data_retention_time"></a> [data\_retention\_time](#input\_data\_retention\_time) | Data retention time. | `number` | `30` | no |
| <a name="input_prometheus_instance_id"></a> [prometheus\_instance\_id](#input\_prometheus\_instance\_id) | ID of Prometheus Instance. | `bool` | `true` | no |
| <a name="input_prometheus_instance_name"></a> [prometheus\_instance\_name](#input\_prometheus\_instance\_name) | Name of Prometheus instance to be created. | `string` | `null` | no |
| <a name="input_prometheus_tags"></a> [prometheus\_tags](#input\_prometheus\_tags) | Tags of the Prometheus instance to be created. | `map(string)` | `{}` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet Id of Prometheus instance. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Vpc Id of Prometheus instance. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_prometheus_id"></a> [prometheus\_id](#output\_prometheus\_id) | The Id of Prometheus Instance. |
<!-- END_TF_DOCS -->

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
