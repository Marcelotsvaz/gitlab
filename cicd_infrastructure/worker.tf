module worker {
	source = "gitlab.com/vaz-projects/auto-scaling-group/aws"
	version = "0.3.0"
	
	name = "CI/CD Worker"
	prefix = "${local.project_prefix}-cicd_worker"
	
	ami_id = data.aws_ami.main.id
	user_data_base64 = module.worker_user_data.content_base64
	role_policies = [ data.aws_iam_policy_document.worker_autoscaler ]
	
	subnet_ids = module.vpc.networks.public[*].id
	security_group_ids = [ module.public_security_group.id ]
	
	root_volume_size = local.worker.root_volume_size
	
	# Auto scaling.
	max_size = local.runner.max_instances
	protect_from_scale_in = true
	suspended_processes = [ "AZRebalance" ]	# TODO: Test AZRebalance
	lifecycle_hooks = [
		{
			name = "worker_ready"
			type = "launching"
		},
	]
}


module worker_user_data {
	source = "gitlab.com/vaz-projects/user-data/external"
	version = "1.0.2"
	
	input_dir = "${path.root}/scripts/worker/"
	
	files = [ "perInstance.sh" ]
	
	environment = {
		AWS_DEFAULT_REGION = data.aws_region.main.name
		hostname = "cicd-worker"
		worker_user = local.worker.user
		auto_scaling_group_name = module.worker.name
	}
}


data aws_iam_policy_document worker_autoscaler {
	policy_id = "worker_autoscaler"
	
	statement {
		actions = [ "autoscaling:CompleteLifecycleAction" ]
		resources = [ module.worker.arn ]
	}
}