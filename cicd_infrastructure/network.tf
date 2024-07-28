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



# 
# Security Groups
#-------------------------------------------------------------------------------
module public_security_group {
	source = "gitlab.com/vaz-projects/security-group/aws"
	version = "0.2.0"
	
	vpc_id = module.vpc.id
	
	name_prefix = local.project_name
	name = "Public"
	
	allow_all_egress = true
	
	ingress_from = [
		{
			name = "ICMP Ping"
			cidr_ipv4 = "0.0.0.0/0"
			protocol = "icmp"
			port = 8	# Type: Echo request.
			to_port = 0	# Code: No Code.
		},
		{
			name = "ICMPv6 Ping"
			cidr_ipv6 = "::/0"
			protocol = "icmpv6"
			port = 128	# Type: Echo request.
			to_port = 0	# Code: No Code.
		},
		{
			name = "SSH"
			cidr_ipv4 = "0.0.0.0/0"
			cidr_ipv6 = "::/0"
			protocol = "tcp"
			port = 22
		},
	]
}