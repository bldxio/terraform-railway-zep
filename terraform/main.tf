# Terraform Providers
terraform {
  required_providers {
    railway = {
      source  = "terraform-community-providers/railway"
      version = ">= 0.4.4"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.3"
    }
  }
}

# Railway Project
module "railway_project" {
  source      = "git::https://github.com/bldxio/terraform-railway-railway-project"
  name        = var.name
  environment = var.environment
  team_id     = var.team_id
}

# Railway Services within the project

resource "railway_service" "pgvector" {
  depends_on         = [module.railway_project]
  project_id         = module.railway_project.id
  name               = "postgres"
  source_repo        = "bldxio/pgvector"
  source_repo_branch = "master"
  config_path        = "railway-pgvector.toml"
  volume             = { name = "postgres-data", mount_path = "/var/lib/postgresql/data" }
}

resource "null_resource" "pgvector_delay" {
  depends_on = [railway_service.pgvector]
  provisioner "local-exec" {
    command = "sleep 30" # Wait 30 seconds
  }
}

resource "railway_tcp_proxy" "pgvector" {
  application_port = 5432
  environment_id   = railway_project.environment.default_environment.id
  service_id       = railway_service.pgvector.id
}

resource "railway_service" "graphiti" {
  depends_on   = [railway_service.pgvector, null_resource.pgvector_delay]
  project_id   = module.railway_project.id
  name         = "graphiti"
  source_image = "zepai/graphiti:0.3"
  volume       = { name = "graphiti-data", mount_path = "/app/data" }
}

resource "null_resource" "graphiti_delay" {
  depends_on = [railway_service.graphiti]
  provisioner "local-exec" {
    command = "sleep 30" # Wait 30 seconds
  }
}

resource "railway_service" "neo4j" {
  depends_on   = [railway_service.graphiti, null_resource.graphiti_delay]
  project_id   = module.railway_project.id
  name         = "neo4j"
  source_image = "neo4j:5.22.0"
  volume       = { name = "neo4j-data", mount_path = "/data" }
}

resource "null_resource" "neo4j_delay" {
  depends_on = [railway_service.neo4j]
  provisioner "local-exec" {
    command = "sleep 30" # Wait 30 seconds
  }
}

resource "railway_service" "zep" {
  depends_on         = [railway_service.neo4j, null_resource.neo4j_delay]
  project_id         = module.railway_project.id
  name               = var.name
  source_repo        = "bldxio/zep"
  source_repo_branch = "main"
  config_path        = "railway.toml"
  volume             = { name = "zep-data", mount_path = "/app/" }
}