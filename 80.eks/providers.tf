terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "statefile-example"
    key    = "eks-statefile"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true

  }
}
    # - as we created 2 different backend bucket in tfvars that is not required in workspaces.
		# - only one bucket is enough ...workspaces will craete themselves a separate folders for different environments and stores their 
		# state files in that folders.
		# - give keyname -> name of state file that is created
    
provider "aws" {
  # Configuration options
  #configure in your own system using aws configure it's more secure than configuring here itself
  region = "us-east-1"
}