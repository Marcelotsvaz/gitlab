echo Setting up environment...



# Always run on project root.
pushd $(status dirname)/../ || exit



# Manually set GitLab CI/CD variables when running locally.
if not set --query GITLAB_CI
	echo 'Running outside CI/CD.'
	
	source .staging/local.fish
	or echo You must configure your local environment with `.staging/local.fish`. && popd && exit 1
	
	# Get project path from git remote URL.
	set gitRemote $(git rev-parse --abbrev-ref HEAD@{upstream} | string split / --fields 1)
	set CI_PROJECT_PATH $(git remote get-url $gitRemote | string match --regex --groups ':(.+)\.git$')
	set CI_API_V4_URL https://gitlab.com/api/v4
end



# Terraform HTTP backend setup.
set escapedProjectPath $(string replace --all --regex '/' '%2F' $CI_PROJECT_PATH)
set stateName gitlab
set -x TF_HTTP_ADDRESS $CI_API_V4_URL/projects/$escapedProjectPath/terraform/state/$stateName
set -x TF_HTTP_LOCK_ADDRESS $TF_HTTP_ADDRESS/lock
set -x TF_HTTP_UNLOCK_ADDRESS $TF_HTTP_ADDRESS/lock
set -x TF_HTTP_USERNAME gitlab-ci-token
set -x TF_HTTP_PASSWORD $gitlabAccessToken $CI_JOB_TOKEN && set TF_HTTP_PASSWORD $TF_HTTP_PASSWORD[1]

# Terraform setup.
set -x TF_DATA_DIR $PWD/.staging/terraform/

# Terraform variables.
set -x TF_VAR_gitlab_access_token $gitlabAccessToken
set -x TF_VAR_github_access_token $githubAccessToken



# Go back to initial directory.
popd