provider "aws" {
  region = "ap-south-1"
}

# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "weather-api-app-state-bucket"
    key     = "terraform.tfstate"
    region  = "ap-south-1"
  }
}