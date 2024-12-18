# Terraform Module for Zep Memory Application

This Terraform module sets up the infrastructure for the Zep Memory Application using Railway services. It provisions services like `pgvector`, `graphiti`, `neo4j`, and `zep` with necessary configurations and environment variables. More information can be seen at [terraform-railway-zep](https://app.terraform.io/app/BLDX/registry/modules/private/BLDX/zep/railway/0.0.2). To see an example of an upstream application using this module refer to <https://github.com/bldxio/infra-prod/tree/main/apps/zep>

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "zep_memory" {
  source = "./terraform"

  name                = "your_project_name"
  environment         = "your_environment"
  openai_api_key      = "your_openai_api_key"
  model               = "your_model_name"
  team_id             = "your_team_id"
  resource_identifiers = ["pgvector", "zep", "neo4j"]
}
```

## Variables

- **name**: (string) Name of the project.
- **environment**: (string) The environment name for the project. Default is "prd".
- **openai_api_key**: (string) OpenAI API key.
- **model**: (string) The model name to be used in graphiti. Default is "gpt-4o".
- **team_id**: (string) Your team's ID in railway.
- **resource_identifiers**: (list(string)) The resource identifiers for the project. Default is ["pgvector", "zep", "neo4j"]. This needs to be the names of the services you will be using the random password module in if using it.

## Outputs

- **passwords_map**: A map of generated passwords for the services.

## Providers

- **railway**: Manages Railway services.
- **random**: Generates random values for passwords.

## Resources

- **railway_service**: Manages Railway services for `pgvector`, `graphiti`, `neo4j`, and `zep`.
- **railway_tcp_proxy**: Sets up TCP proxy for `pgvector`.
- **null_resource**: Used for delays between service provisioning.
  > **Note** this is only necessary due to railways rate limits on volume cratiion, and service creation.

## Modules

- **passwords**: Generates random passwords for the services.

## Notes

- Ensure that the `secret` value is set in the `zep.yaml` configuration file.
- Expose an `OPENAI_API_KEY` environment variable either in a local .env file or by running `export OPENAI_API_KEY=your_openai_api_key`.
