terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "statefile-example"
    key    = "certificate-statefile"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true

  }
}

    
provider "aws" {
  # Configuration options
  #configure in your own system using aws configure it's more secure than configuring here itself

}