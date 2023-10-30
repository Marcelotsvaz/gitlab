# GitLab Utils
This repository holds several resources used by my other repositories on GitLab.


## CI/CD Components
Reusable [components](https://docs.gitlab.com/ee/ci/components/) for GitLab CI/CD pipelines.

- `sane-workflow` - Prevent duplicated pipelines.
- `stages` - Default stages used in all my projects.

How to use:
```yaml
include:
  - component: gitlab.com/marcelotsvaz/gitlab/stages@main
```


## GitLab Runners
TODO


## Renovate Presets
TODO


## GitLab Project Configuration as Code
TODO