# Railway Environment Variables per service

# password module
module "password" {
  source = "git::https://github.com/bldxio/terraform-random-password"
}

# zep
resource "railway_variable_collection" "zep" {
  environment_id = module.railway_project.environment_id
  service_id     = railway_service.zep.id

  variables = [
    {
      name  = "ZEP_CONFIG_FILE"
      value = "zep.yaml"
    },
    {
      name  = "POSTGRES_USER"
      value = var.platform
    },
    {
      name  = "POSTGRES_PASSWORD"
      value = module.password.result
    },
    {
      name  = "POSTGRES_DB"
      value = var.platform
    },
    {
      name  = "PGHOST_PRIVATE"
      value = "$${{postgres.PGHOST_PRIVATE}}"
    },
    {
      name  = "PGPORT_PRIVATE"
      value = "5432"
    },
    {
      name  = "GRAPHITI_HOST_PRIVATE"
      value = "$${{graphiti.GRAPHITI_HOST_PRIVATE}}"
    }
  ]
}

# graphiti
resource "railway_variable_collection" "graphiti" {
  environment_id = module.railway_project.environment_id
  service_id     = railway_service.graphiti.id

  variables = [
    {
      name  = "OPENAI_API_KEY"
      value = var.openai_api_key
    },
    {
      name  = "GRAPHITI_HOST_PRIVATE"
      value = "$${{RAILWAY_PRIVATE_DOMAIN}}"
    },
    {
      name  = "MODEL_NAME"
      value = var.model
    },
    {
      name  = "NEO4J_URI"
      value = "bolt://$${{neo4j.NEO4J_HOST_PRIVATE}}:$${{neo4j.NEO4J_PORT_PRIVATE}}"
    },
    {
      name  = "NEO4J_USER"
      value = var.neo4j_user
    },
    {
      name  = "NEO4J_PASSWORD"
      value = "$${{neo4j.NEO4J_PASSWORD}}"
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
      name  = "DATABASE_PRIVATE_URL"
      value = "postgres://$${{POSTGRES_USER}}:$${{POSTGRES_PASSWORD}}@$${{PGHOST_PRIVATE}}:$${{PGPORT_PRIVATE}}/$${{POSTGRES_DB}}"
    },
    {
      name  = "DATABASE_URL"
      value = "postgres://$${{POSTGRES_USER}}:$${{POSTGRES_PASSWORD}}@$${{PGHOST}}:$${{PGPORT}}/$${{POSTGRES_DB}}"
    },
    {
      name  = "PGDATA"
      value = "/var/lib/postgresql/data/pgdata"
    },
    {
      name  = "PGHOST"
      value = "$${{RAILWAY_TCP_PROXY_DOMAIN}}"
    },
    {
      name  = "PGHOST_PRIVATE"
      value = "$${{RAILWAY_PRIVATE_DOMAIN}}"
    },
    {
      name  = "PGPORT"
      value = "5432"
    },
    {
      name  = "PGPORT_PRIVATE"
      value = "5432"
    },
    {
      name  = "POSTGRES_DB"
      value = var.platform
    },
    {
      name  = "POSTGRES_PASSWORD"
      value = module.password.result
    },
    {
      name  = "POSTGRES_USER"
      value = var.platform
    },
    {
      name  = "SSL_CERT_DAYS"
      value = "820"
    }
  ]
}

resource "railway_variable_collection" "neo4j" {
  environment_id = module.railway_project.environment_id
  service_id     = railway_service.neo4j.id

  variables = [
    {
      name  = "NEO4J_AUTH"
      value = "neo4j/${module.password.result}"
    },
    {
      name  = "NEO4J_PASSWORD"
      value = "${module.password.result}"
    },
    {
      name  = "NEO4J_HOST_PRIVATE"
      value = "$${{RAILWAY_PRIVATE_DOMAIN}}"
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
