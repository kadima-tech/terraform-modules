## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_subnetwork.internal-connector-subnet](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_subnetwork) | resource |
| [google-beta_google_vpc_access_connector.connector](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_vpc_access_connector) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_network"></a> [private\_network](#input\_private\_network) | n/a | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
