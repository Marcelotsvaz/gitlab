data gitlab_group main {
	full_path = "vaz-projects"
}


resource gitlab_user_runner main {
	runner_type = "group_type"
	group_id = data.gitlab_group.main.id
}