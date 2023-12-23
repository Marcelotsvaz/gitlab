terraform {
	required_version = ">= 1.6.4"
	
	required_providers {
		gitlab = {
			source = "gitlabhq/gitlab"
			version = "16.6.0"
		}
	}
}


provider gitlab {
	token = var.gitlab_access_token
}