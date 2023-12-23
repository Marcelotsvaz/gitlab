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
					infrastructure_access_level = "private"
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
	
	
	# Append the namespace to each project's path. Prepare default options to be deep merged.
	flattened_projects = merge( [
		for namespace, projects in local.namespaces:
		{
			for path, project in projects:
			"${namespace}/${path}" => [
				{
					namespace = namespace
					path = path
				},
				lookup( local.namespaces, "_defaults", {} ),
				lookup( projects, "_defaults", {} ),
				project,
			]
			if path != "_defaults"
		}
		if namespace != "_defaults"
	]... )
	
	# Group options by key..
	coalesced_projects = {
		for full_path, project in local.flattened_projects:
		full_path => {
			for key in toset( flatten( [ for options in project: keys( options ) ] ) ):
			key => [ for options in project: lookup( options, key, null ) if lookup( options, key, null ) != null ]
		}
	}
	
	# Deep merge (only 2 levels) options.
	merged_projects = {
		for full_path, project in local.coalesced_projects:
		full_path => {
			for key, values in project:
			key => try( merge( values... ), concat( values... ), values[length( values ) - 1] )
		}
	}
}



module project {
	source = "gitlab.com/vaz-projects/gitlab-project/gitlab"
	version = "0.1.0"
	
	for_each = local.merged_projects
	
	name = each.value.name
	path = each.value.path
	namespace = each.value.namespace
	
	topics = each.value.topics
	description = each.value.description
	visibility_level = each.value.visibility_level
	
	features = each.value.features
}