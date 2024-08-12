module server {
	source = "gitlab.com/vaz-projects/instance/aws"
	version = "0.4.0"
	
	name = "CI/CD Server"
	prefix = "${local.project_prefix}-cicd_server"
	
	min_vcpu_count = 2
	min_memory_gib = 1
	max_instance_price = 0.025
	
	ami_id = data.aws_ami.main.id
	user_data_base64 = module.server_user_data.content_base64
	role_policies = [
		data.aws_iam_policy_document.runner_cache,
		data.aws_iam_policy_document.runner_autoscaler,
	]
	
	subnet_ids = module.vpc.networks.public[*].id
	security_group_ids = [ module.public_security_group.id ]
	
	root_volume_size = 10
}


data aws_ami main {
	most_recent = true
	owners = [ "self" ]
	
	filter {
		name = "name"
		values = [ "${local.project_name} Worker AMI" ]
	}
}


module server_user_data {
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
		AWS_DEFAULT_REGION = data.aws_region.main.name
		hostname = "cicd"
	}
	context = {
		runner_name = gitlab_user_runner.main.description
		gitlab_url = var.gitlab_url
		runner_id = gitlab_user_runner.main.id
		runner_token = gitlab_user_runner.main.token
		
		runner_max_instances = local.runner.max_instances
		runner_instance_concurrency = local.runner.instance_concurrency
		runner_instance_use_count = local.runner.instance_use_count
		runner_auto_scaling_group_name = module.worker.name
		runner_worker_user = local.worker.user
		runner_idle_time = local.runner.idle_time
		
		runner_cache_bucket_name = aws_s3_bucket.runner_cache.id
		runner_cache_bucket_region = aws_s3_bucket.runner_cache.region
	}
}


data aws_region main {}


data aws_iam_policy_document runner_cache {
	policy_id = "runner_cache"
	
	statement {
		actions = [
			"s3:GetObject",
			"s3:PutObject",
		]
		resources = [ "${aws_s3_bucket.runner_cache.arn}/*" ]
	}
}


data aws_iam_policy_document runner_autoscaler {
	policy_id = "runner_autoscaler"
	
	statement {
		actions = [
			"autoscaling:DescribeAutoScalingGroups",
			"ec2:DescribeInstances",
		]
		resources = [ "*" ]
	}
	
	statement {
		actions = [
			"autoscaling:SetDesiredCapacity",
			"autoscaling:TerminateInstanceInAutoScalingGroup",
		]
		resources = [ module.worker.arn ]
	}
	
	statement {
		actions = [ "ec2-instance-connect:SendSSHPublicKey" ]
		resources = [ "*" ]
		condition {
			variable = "aws:ResourceTag/aws:autoscaling:groupName"
			test = "StringEquals"
			values = [ module.worker.name ]
		}
		condition {
			variable = "ec2:osuser"
			test = "StringEquals"
			values = [ local.worker.user ]
		}
	}
}