terraform {
	required_version = ">= 1.6.4"
	
	required_providers {
		gitlab = {
			source = "gitlabhq/gitlab"
			version = "16.6.0"
		}
	}
	
	backend http {
		lock_method = "POST"
		unlock_method = "DELETE"
	}
}


provider gitlab {
	token = var.gitlab_access_token
}