provider aws {
	default_tags {
		tags = {
			Project = local.project_name
		}
	}
}


provider gitlab {
	base_url = var.gitlab_url
	token = var.gitlab_access_token
}