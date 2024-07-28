variable gitlab_access_token {
	description = "GitLab Personal Access Token with api scope."
	type = string
	sensitive = true
}



locals {
	project_name = "CI/CD Infrastructure"
	project_identifier = "cicd_infrastructure"
	project_prefix = local.project_identifier
}