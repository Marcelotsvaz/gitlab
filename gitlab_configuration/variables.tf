variable gitlab_access_token {
	description = "GitLab Personal Access Token."
	type = string
	sensitive = true
}

variable github_access_token {
	description = "GitHub Personal Access Token."
	type = string
	sensitive = true
}



locals {
	namespaces = {
		_defaults = {
			topics = []
			visibility_level = "public"
		}
		
		
		"vaz-projects" = {
			gitlab = {
				name = "GitLab Components"
				description = "Different types of reusable components used across all my projects on GitLab."
				avatar = "avatars/gitlab.png"
				topics = [
					"gitlab",
				]
				
				features = {
					builds_access_level = "enabled"
					container_registry_access_level = "enabled"
					infrastructure_access_level = "enabled"
					releases_access_level = "enabled"
				}
			}
			
			vaz-projects = {
				name = "VAZ Projects"
				description = "VAZ Projects website."
				topics = [
					"aws",
					"terraform",
					"docker",
					"django",
				]
				
				features = {
					builds_access_level = "enabled"
					container_registry_access_level = "enabled"
					environments_access_level = "enabled"
					infrastructure_access_level = "enabled"
					monitor_access_level = "enabled"
					snippets_access_level = "enabled"
				}
				
				github_mirror = {
					name = "vaz-projects"
					homepage_url = "https://vazprojects.com"
				}
			}
			
			python-project-template = {
				name = "Python Project Template"
				description = "Template to quickly bootstrap Python projects."
				avatar = "avatars/python.png"
				topics = [
					"python",
					"template-project",
				]
				
				features = {
					builds_access_level = "enabled"
					environments_access_level = "enabled"
					packages_enabled = true
					pages_access_level = "enabled"
					releases_access_level = "enabled"
				}
				
				github_mirror = {
					name = "python-project-template"
					homepage_url = "https://gitlab.com/marcelotsvaz/python-project-template"
					is_template = true
				}
			}
			
			nbr-5410-calculator = {
				name = "NBR 5410 Calculator"
				description = "Calculator for electrical installations following the NBR 5410 standard."
				topics = [
					"Qt",
					"python",
				]
				
				features = {
					builds_access_level = "enabled"
					releases_access_level = "enabled"
				}
				
				github_mirror = {
					name = "nbr-5410-calculator"
				}
			}
			
			arch-linux-install-script = {
				name = "Arch Linux Install Script"
				description = "Arch Linux install and configuration script."
				avatar = "avatars/arch_linux.png"
				topics = [
					"archlinux",
					"linux",
					"python",
				]
				
				github_mirror = {
					name = "arch-linux-install-script"
				}
			}
		}
		
		
		"vaz-projects/terraform" = {
			_defaults = {
				description = "Terraform module."
				topics = [
					"terraform",
				]
				
				features = {
					builds_access_level = "enabled"
					packages_enabled = true
					releases_access_level = "enabled"
				}
			}
			
			vpc = {
				name = "AWS VPC Terraform Module"
				avatar = "avatars/vpc.png"
			}
			
			security-group = {
				name = "AWS Security Group Terraform Module"
				avatar = "avatars/vpc.png"
			}
			
			instance = {
				name = "AWS EC2 Instance Terraform Module"
				avatar = "avatars/ec2.png"
			}
			
			auto-scaling-group = {
				name = "AWS EC2 Auto Scaling Group Terraform Module"
				avatar = "avatars/auto_scaling.png"
			}
			
			user-data = {
				name = "AWS EC2 User Data Terraform Module"
				avatar = "avatars/ec2.png"
				
				github_mirror = {
					name = "terraform-external-user-data"
				}
			}
			
			lambda = {
				name = "AWS Lambda Terraform Module"
				avatar = "avatars/lambda.png"
				
				github_mirror = {
					name = "terraform-aws-lambda"
				}
			}
			
			eks = {
				name = "AWS EKS Terraform Module"
				avatar = "avatars/eks.png"
			}
			
			gitlab-project = {
				name = "GitLab Project Terraform Module"
				avatar = "avatars/gitlab.png"
			}
		}
	}
}