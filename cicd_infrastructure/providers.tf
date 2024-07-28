provider aws {
	default_tags {
		tags = {
			Project = local.project_name
		}
	}
}


provider gitlab {
	token = var.gitlab_access_token
}