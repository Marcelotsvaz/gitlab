source amazon-ebssurrogate main {
	# 
	# Builder options.
	#---------------------------------------------------------------------------
	spot_price = 0.05
	spot_instance_types = [
		"t3.micro",
		"t3.small",
		"t3.medium",
		"t3a.micro",
		"t3a.small",
		"t3a.medium",
	]
	
	user_data_file = "../../.staging/user_data.tar.gz"
	ebs_optimized = true
	
	ssh_username = "packer"
	ssh_pty = true
	
	subnet_filter {
		filters = {
			"tag:Project" = local.project_name
		}
		random = true
	}
	
	security_group_filter {
		filters = {
			"tag:Name" = "${local.project_name} Public Security Group"
			"tag:Project" = local.project_name
		}
	}
	
	source_ami_filter {
		most_recent = true
		owners = [ "self" ]
		
		filters = {
			name = local.ami_name
		}
	}
	
	# Builder root.
	launch_block_device_mappings {
		device_name = "/dev/xvda"
		volume_size = 10
		delete_on_termination = true
		omit_from_artifact = true
	}
	
	# Image root.
	launch_block_device_mappings {
		device_name = "/dev/xvdf"
		volume_size = var.disk_size
		volume_type = "gp3"
		encrypted = true
		delete_on_termination = true
	}
	
	run_tags = {
		Name = "${local.ami_name} Builder"
		Project = local.project_name
	}
	
	run_volume_tags = {
		Name = "${local.ami_name} Builder Volume"
		Project = local.project_name
	}
	
	spot_tags = {
		Name = "${local.ami_name} Builder Spot Request"
		Project = local.project_name
	}
	
	
	# 
	# AMI options.
	#---------------------------------------------------------------------------
	ami_name = local.ami_name
	ami_virtualization_type = "hvm"
	boot_mode = "uefi"
	# Add UEFI boot entry to File(\linux.efi).
	uefi_data = "QU1aTlVFRkma4sWCAAAAAHj5a7fZ92OC2sQJpUGDbv5FKalFTHBHoFvODp1mgSk3AAIrpAk2OQZHoOOSgS0iBQYf8MrBUvAsJguLFEMMeMUdREQPWO6kAXmQliE2WwB/sh9R"
	ena_support = true
	
	force_deregister = true
	force_delete_snapshot = true
	
	ami_root_device {
		source_device_name = "/dev/xvdf"
		device_name = "/dev/xvda"
	}
	
	tags = {
		Name = local.ami_name
		Project = local.project_name
	}
	
	snapshot_tags = {
		Name = "${local.ami_name} Snapshot"
		Project = local.project_name
	}
}



build {
	sources = [ "source.amazon-ebssurrogate.main" ]
	
	provisioner ansible-local {
		command = "./sudo_ansible_playbook.sh"
		
		playbook_dir = "."
		playbook_file = var.playbook
	}
}