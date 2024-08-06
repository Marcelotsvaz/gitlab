locals {
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
	version = "0.2.0"
	
	for_each = local.merged_projects
	
	name = each.value.name
	path = each.value.path
	namespace = each.value.namespace
	
	topics = each.value.topics
	description = each.value.description
	avatar = lookup( each.value, "avatar", null )
	visibility_level = each.value.visibility_level
	
	features = each.value.features
	cicd = each.value.cicd
}