module server {
	source = "gitlab.com/vaz-projects/instance/aws"
	version = "0.2.1"
	
	name = "CI/CD Server"
	prefix = "${local.project_prefix}-cicd_server"
	
	subnet_ids = module.vpc.networks.public[*].id
	security_group_ids = [ module.public_security_group.id ]
}