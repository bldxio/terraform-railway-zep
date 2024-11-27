# Global variables go here
variable "name" {
  description = "Name of the project"
  type        = string
  default     = ""
}

variable "environment" {
  description = "The environment name for the project"
  type        = string
  default     = "prd"
}

variable "openai_api_key" {
  description = "OpenAI API key"
  type        = string
}

variable "model" {
  description = "The model name to be used in graphiti"
  type        = string
  default     = "gpt-4o"
}

variable "team_id" {
  description = "The team ID for the project"
  type        = string
}

variable "resource_identifiers" {
  description = "The resource identifier for the project"
  type        = list(string)
  default     = ["pgvector", "zep", "neo4j"]
}
