# 
# VPC
#-------------------------------------------------------------------------------
module vpc {
	source = "gitlab.com/vaz-projects/vpc/aws"
	version = "0.2.1"
	
	name = local.project_name
	
	networks = {
		public = {
			name = "%s - Public"
			public = true
		}
	}
}