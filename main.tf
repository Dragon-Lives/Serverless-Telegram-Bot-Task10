provider "aws" { region = "us-east-1" }

variable "weather_api_key" {}
variable "telegram_token" {}
variable "project_id" {}

module "storage" {
  source = "./modules/storage"
  bucket_name = "srh-${var.project_id}-files"
}

module "database" {
  source = "./modules/database"
  table_name = "srh-${var.project_id}-notes"
}

module "compute" {
  source          = "./modules/compute"
  bucket_name     = module.storage.bucket_name
  table_name      = module.database.table_name
  table_arn       = module.database.table_arn
  weather_api_key = var.weather_api_key
  telegram_token  = var.telegram_token
}

output "api_url" { value = module.compute.api_endpoint }