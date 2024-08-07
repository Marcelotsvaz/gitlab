variable gitlab_url {
	description = "URL of the GitLab instance."
	type = string
	default = "https://gitlab.com"
}

variable gitlab_access_token {
	description = "GitLab Personal Access Token with api scope."
	type = string
	sensitive = true
}



locals {
	project_name = "CI/CD Infrastructure"
	project_identifier = "cicd_infrastructure"
	project_prefix = local.project_identifier
	project_prefix_alternate = replace( local.project_prefix, "_", "-" )
	
	runner = {
		idle_instances = 0
		max_instances = 15
		instance_concurrency = 1
		instance_use_count = 10
	}
	
	worker = {
		root_volume_size = 10
		user = "worker"
	}
}