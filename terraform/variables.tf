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

variable "platform" {
  description = "The cloud platform for the project"
  type        = string
  default     = "railway"
}

variable "model" {
  description = "The model name to be used in graphiti"
  type        = string
  default     = "gpt-4o"
}

variable "neo4j_user" {
  description = "Neo4j user"
  type        = string
  default     = "neo4j"
}

variable "team_id" {
  description = "The team ID for the project"
  type        = string
}
