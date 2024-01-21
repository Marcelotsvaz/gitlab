# GitLab Utils
This repository holds several resources used by my other repositories on GitLab.


## CI/CD Components
Reusable [components](https://docs.gitlab.com/ee/ci/components/) for GitLab CI/CD pipelines.

- `sane-workflow` - Prevent duplicated pipelines.
- `stages` - Default stages used in all my projects.

How to use:
```yaml
include:
  - component: gitlab.com/vaz-projects/gitlab/stages@1.0.0
```


### Deployment Styles
The `stages` component support two different deployment styles:

1. Deploy on tag pipelines. Default branch is used pro development. Good for versioned releases.
    - `feature-branch/without-mr`: Build & Test
    - `feature-branch/with-mr`: Build & Test -> Deploy to review app
    - `default-branch`: Build & Test
    - `tag`: Build & Test -> Deploy to staging -> Deploy to production
    
1. Deploy on default branch pipelines. Default branch is used for staging and production. Good for continuous delivery/deployment.
    - `feature-branch/without-mr`: Build & Test
    - `feature-branch/with-mr`: Build & Test -> Deploy to review app
    - `default-branch`: Build & Test -> Deploy to staging -> Deploy to production
    - `tag`: Build & Test

``` yaml
include:
    - component: gitlab.com/vaz-projects/gitlab/stages@1.0.0
      inputs:
        deployOn: defaultBranch
```


## GitLab Runners
TODO


## Renovate Presets
TODO


## GitLab Project Configuration as Code
TODO