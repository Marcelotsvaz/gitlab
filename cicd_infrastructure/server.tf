module server {
	source = "gitlab.com/vaz-projects/instance/aws"
	version = "0.3.0"
	
	name = "CI/CD Server"
	prefix = "${local.project_prefix}-cicd_server"
	
	ami_id = data.aws_ami.main.id
	user_data_base64 = module.user_data.content_base64
	role_policies = [ data.aws_iam_policy_document.server ]
	
	subnet_ids = module.vpc.networks.public[*].id
	security_group_ids = [ module.public_security_group.id ]
	
	root_volume_size = 10
}


data aws_ami main {
	most_recent = true
	owners = [ "self" ]
	
	filter {
		name = "name"
		values = [ "VAZ Projects Builder AMI" ]
	}
}


module user_data {
	source = "gitlab.com/vaz-projects/user-data/external"
	version = "1.0.2"
	
	input_dir = "${path.root}/scripts/"
	
	files = [
		"gitlab-runner.service",
		"perInstance.sh",
	]
	templates = [
		"config.toml.tftpl",
	]
	
	environment = {
		hostname = "cicd"
	}
	context = {
		runner_name = gitlab_user_runner.main.description
		gitlab_url = var.gitlab_url
		runner_id = gitlab_user_runner.main.id
		runner_token = gitlab_user_runner.main.token
		runner_cache_bucket_name = aws_s3_bucket.runner_cache.id
		runner_cache_bucket_region = aws_s3_bucket.runner_cache.region
	}
}


data aws_iam_policy_document server {
	statement {
		sid = "putRunnerCache"
		actions = [
			"s3:GetObject",
			"s3:PutObject",
		]
		resources = [ "${aws_s3_bucket.runner_cache.arn}/*" ]
	}
}