## Requirements

No requirements.

## Providers

| Name                                                      | Version |
| --------------------------------------------------------- | ------- |
| <a name="provider_google"></a> [google](#provider_google) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                                  | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [google_project_iam_member.cloudrun_container_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member)                              | resource |
| [google_project_iam_member.cloudrun_deployer_deploy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member)                               | resource |
| [google_project_iam_member.cloudrun_deployer_impersonate](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member)                          | resource |
| [google_project_service.project_cloudrun_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service)                                         | resource |
| [google_secret_manager_secret.cloudrun_deployer_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)                         | resource |
| [google_secret_manager_secret_version.cloudrun_deployer_secret_version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.cloudrun_deployer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account)                                            | resource |
| [google_service_account_key.githubactions_cloudrun_deployer_access_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key)           | resource |
| [google_storage_bucket_iam_member.cloudrun_deployer_upload](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member)                 | resource |

## Inputs

| Name                                                                                                            | Description                                                 | Type     | Default | Required |
| --------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_container_registry_project"></a> [container_registry_project](#input_container_registry_project) | The id of the project we want to store docker containers in | `string` | n/a     |   yes    |
| <a name="input_gcloud_project_number"></a> [gcloud_project_number](#input_gcloud_project_number)                | The number of the project we want to enable cloudrun on     | `number` | n/a     |   yes    |
| <a name="input_project"></a> [project](#input_project)                                                          | The id of the project we want to enable cloudrun on         | `string` | n/a     |   yes    |

## Outputs

No outputs.
