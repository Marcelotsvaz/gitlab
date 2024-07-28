terraform {
	required_version = ">= 1.9.1"
	
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "5.57.0"
		}
		
		gitlab = {
			source = "gitlabhq/gitlab"
			version = "17.2.0"
		}
	}
	
	backend http {
		lock_method = "POST"
		unlock_method = "DELETE"
	}
}