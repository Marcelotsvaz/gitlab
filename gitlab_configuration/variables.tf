variable gitlab_access_token {
	description = "GitLab Personal Access Token with api scope."
	type = string
	sensitive = true
}



locals {
	namespaces = {
		_defaults = {
			topics = []
			visibility_level = "public"
			
			features = {}
		}
		
		
		"vaz-projects" = {
			gitlab = {
				name = "GitLab Components"
				description = "Different types of reusable components used across all my projects on GitLab."
				topics = [ "gitlab" ]
				
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
			}
			
			python-project-template = {
				name = "Python Project Template"
				description = "Template to quickly bootstrap Python projects."
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
			}
			
			arch-linux-install-script = {
				name = "Arch Linux Install Script"
				description = "Arch Linux install and configuration script."
				topics = [
					"archlinux",
					"linux",
					"python",
				]
			}
		}
		
		
		"vaz-projects/terraform" = {
			_defaults = {
				description = "Terraform module."
				topics = [ "terraform" ]
				
				features = {
					builds_access_level = "enabled"
					packages_enabled = true
					releases_access_level = "enabled"
				}
			}
			
			vpc = {
				name = "AWS VPC Terraform Module"
			}
			
			security-group = {
				name = "AWS Security Group Terraform Module"
			}
			
			instance = {
				name = "AWS EC2 Instance Terraform Module"
			}
			
			user-data = {
				name = "AWS EC2 User Data Terraform Module"
			}
			
			lambda = {
				name = "AWS Lambda Terraform Module"
			}
			
			eks = {
				name = "AWS EKS Terraform Module"
			}
			
			gitlab-project = {
				name = "GitLab Project Terraform Module"
			}
		}
	}
}