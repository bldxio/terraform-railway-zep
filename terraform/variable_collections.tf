# Railway Environment Variables per service

# password module
module "passwords" {
  source              = "git::https://github.com/bldxio/terraform-random-password"
  for_each            = toset(var.resource_identifiers)
  length              = 32
  resource_identifier = each.key
}

# zep
resource "railway_variable_collection" "zep" {
  environment_id = module.railway_project.environment_id
  service_id     = railway_service.zep.id

  variables = [
    {
      name  = "API_SECRET"
      value = var.openai_api_key
    },
    {
      name  = "GRAPHITI_URL"
      value = "$${{graphiti.GRAPHITI_HOST_PRIVATE}}"
    },
    {
      name  = "PGHOST"
      value = "$${{pgvector.PGHOST}}"
    },
    {
      name  = "PGPORT"
      value = "$${{pgvector.PGPORT}}"
    },
    {
      name  = "PORT"
      value = "8000"
    },
    {
      name  = "POSTGRES_DB"
      value = "$${{pgvector.POSTGRES_DB}}"
    },
    {
      name  = "POSTGRES_PASSWORD"
      value = "$${{pgvector.POSTGRES_PASSWORD}}"
    },
    {
      name  = "POSTGRES_USER"
      value = "$${{pgvector.POSTGRES_USER}}"
    }
  ]
}

# graphiti
resource "railway_variable_collection" "graphiti" {
  environment_id = module.railway_project.environment_id
  service_id     = railway_service.graphiti.id

  variables = [
    {
      name  = "GRAPHITI_HOST_PRIVATE"
      value = "$${{RAILWAY_PRIVATE_DOMAIN}}"
    },
    {
      name  = "MODEL_NAME"
      value = var.model
    },
    {
      name  = "NEO4J_PASSWORD"
      value = "$${{neo4j.NEO4J_PASSWORD}}"
    },
    {
      name  = "NEO4J_URI"
      value = "bolt://$${{neo4j.NEO4J_HOST_PRIVATE}}:$${{neo4j.NEO4J_PORT_PRIVATE}}"
    },
    {
      name  = "NEO4J_USER"
      value = "neo4j"
    },
    {
      name  = "OPENAI_API_KEY"
      value = var.openai_api_key
    },
    {
      name  = "PORT"
      value = "8003"
    },
  ]
}

# pgvector
resource "railway_variable_collection" "pgvector" {
  environment_id = module.railway_project.environment_id
  service_id     = railway_service.pgvector.id

  variables = [
    {
      name  = "DATABASE_URL"
      value = "postgres://$${{PGUSER}}:$${{PGPASSWORD}}@$${{PGHOST}}:$${{PGPORT}}/$${{PGDATABASE}}"
    },
    {
      name  = "DATABASE_URL_PRIVATE"
      value = "postgres://$${{PGUSER}}:$${{PGPASSWORD}}@$${{PGHOST_PRIVATE}}:$${{PGPORT_PRIVATE}}/$${{PGDATABASE}}"
    },
    {
      name  = "PGDATA"
      value = "/var/lib/postgresql/data/pgdata"
    },
    {
      name  = "PGDATABASE"
      value = "$${{POSTGRES_DB}}"
    },
    {
      name  = "PGHOST"
      value = "$${{RAILWAY_TCP_PROXY_DOMAIN}}"
    },
    {
      name  = "PGPASSWORD"
      value = "$${{POSTGRES_PASSWORD}}"
    },
    {
      name  = "PGPORT"
      value = "$${{RAILWAY_TCP_PROXY_PORT}}"
    },
    {
      name  = "PGPORT_PRIVATE"
      value = "5432"
    },
    {
      name  = "PGUSER"
      value = "$${{POSTGRES_USER}}"
    },
    {
      name  = "POSTGRES_DB"
      value = "railway"
    },
    {
      name  = "POSTGRES_PASSWORD"
      value = module.passwords["pgvector"].result
    },
    {
      name  = "POSTGRES_USER"
      value = "postgres"
    },
  ]
}

resource "railway_variable_collection" "neo4j" {
  environment_id = module.railway_project.environment_id
  service_id     = railway_service.neo4j.id

  variables = [
    {
      name  = "NEO4J_AUTH"
      value = "neo4j/${module.passwords["neo4j"].result}"
    },
    {
      name  = "NEO4J_HOST_PRIVATE"
      value = "$${{RAILWAY_PRIVATE_DOMAIN}}"
    },
    {
      name  = "NEO4J_PASSWORD"
      value = "${module.passwords["neo4j"].result}"
    },
    {
      name  = "NEO4J_PORT_PRIVATE"
      value = "7687"
    },
    {
      name  = "NEO4J_server_config_strict__validation_enabled"
      value = "false"
    }
  ]
}
