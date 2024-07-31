resource aws_autoscaling_group worker {
	name = "${local.project_prefix}-worker"
	vpc_zone_identifier = module.vpc.networks.public[*].id
	min_size = 0
	max_size = local.runner.max_instances
	protect_from_scale_in = true
	suspended_processes = [ "AZRebalance" ]	# TODO: Test AZRebalance
	
	mixed_instances_policy {
		instances_distribution {
			on_demand_percentage_above_base_capacity = 0	# Use only spot instances.
			spot_allocation_strategy = "price-capacity-optimized"
			spot_max_price = 0.025
		}
		launch_template {
			launch_template_specification {
				launch_template_id = aws_launch_template.worker.id
				version = aws_launch_template.worker.latest_version
			}
		}
	}
	
	dynamic tag {
		for_each = merge( { Name = "CI/CD Worker Auto Scaling Group" }, data.aws_default_tags.main.tags )
		
		content {
			key = tag.key
			value = tag.value
			propagate_at_launch = false
		}
	}
}


data aws_default_tags main {}


resource aws_launch_template worker {
	name = "${local.project_prefix}-worker"
	update_default_version = true
	
	instance_type = "t3.micro" # TODO
	# instance_requirements {
	# 	allowed_instance_types = data.aws_ec2_instance_types.main.instance_types
	# 	burstable_performance = "included"
	# 	vcpu_count { min = var.min_vcpu_count }
	# 	memory_mib { min = var.min_memory_gib * 1024 }
	# }
	image_id = data.aws_ami.main.id
	user_data = module.worker_user_data.content_base64
	
	vpc_security_group_ids = [ module.public_security_group.id ]
	
	block_device_mappings {
		device_name = "/dev/xvda"
		
		ebs {
			volume_size = local.worker.root_volume_size
			encrypted = true
		}
	}
	ebs_optimized = true
	
	dynamic tag_specifications {
		for_each = {
			spot-instances-request = {
				Name = "CI/CD Worker Spot Request"
			}
			instance = {
				Name = "CI/CD Worker"
			}
			volume = {
				Name = "CI/CD Worker Root Volume"
			}
		}
		
		content {
			resource_type = tag_specifications.key
			tags = merge( data.aws_default_tags.main.tags, tag_specifications.value )
		}
	}
	
	tags = {
		Name = "CI/CD Worker Launch Template"
	}
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
	}
}