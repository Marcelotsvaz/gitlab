variable ami_name {
	type = string
	default = "Worker AMI"
}

variable playbook {
	type = string
	default = "ami_playbook.yaml"
}

variable disk_size {
	type = number
	default = 3
}



locals {
	project_name = "CI/CD Infrastructure"
	ami_name = "${local.project_name} ${var.ami_name}"
}