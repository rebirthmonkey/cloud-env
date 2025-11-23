# Exist CCN

Configuration in this directory CCN attachment with exist ccn instance.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >1.81.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | 1.81.44 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ccn"></a> [ccn](#module\_ccn) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [tencentcloud_vpc.vpc](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpc) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ccn_id"></a> [ccn\_id](#output\_ccn\_id) | The ID of CCN. |
<!-- END_TF_DOCS -->
