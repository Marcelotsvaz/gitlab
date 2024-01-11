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
			
			features = {
				issues_enabled = true
				
				repository_access_level = "enabled"
				merge_requests_access_level = "enabled"
				forking_access_level = "enabled"
				lfs_enabled = true
				
				builds_access_level = "disabled"
				container_registry_access_level = "disabled"
				analytics_access_level = "enabled"
				security_and_compliance_access_level = "disabled"
				wiki_access_level = "disabled"
				snippets_access_level = "disabled"
				packages_enabled = false
				model_experiments_access_level = "disabled"
				model_registry_access_level = "disabled"
				pages_access_level = "disabled"
				monitor_access_level = "disabled"
				environments_access_level = "disabled"
				feature_flags_access_level = "disabled"
				infrastructure_access_level = "disabled"
				releases_access_level = "disabled"
				
				service_desk_enabled = false
			}
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
		}
		
		
		"vaz-projects/terraform" = {
			_defaults = {
				description = "Terraform Module."
				topics = [ "terraform" ]
				
				features = {
					builds_access_level = "enabled"
					packages_enabled = true
					releases_access_level = "enabled"
				}
			}
			
			gitlab-project = {
				name = "GitLab Project"
			}
			
			vpc = {
				name = "AWS VPC Terraform Module"
			}
			
			user-data = {
				name = "Terraform User Data Module"
			}
			
			lambda = {
				name = "Terraform AWS Lambda Module"
			}
			
			eks = {
				name = "AWS EKS Terraform Module"
			}
		}
	}
}