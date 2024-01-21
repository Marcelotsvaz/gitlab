# Changelog


## [2.0.0] - 2024-01-21

### Added
- `stages` component: Add support for continuous delivery/deployment pipelines.
- `stages` component: Add prepare stages.
- `stages` component: Merged `sane-workflow` into `stages`.

### Changed
- `stages` component: Don't run pipelines for lightweight tags.

### Removed
- `sane-workflow` component: Merged `sane-workflow` into `stages`.

### Fixed
- `stages` component: Fix scheduled pipelines being run as branch pipelines.


## [1.3.0] - 2024-01-11

### Added
- `docker-image` component: Add component for building Docker images.


## [1.2.0] - 2024-01-10

### Added
- `release` component: Add support for projects without a changelog.


## [1.1.1] - 2024-01-10

### Fixed
- `release` component: Fix path to release description.
- `stages` component: Use non-breaking space in stage name.


## [1.1.0] - 2024-01-08

### Added
- Add changelog.
- Use custom image in CI jobs.
- `release` component: Add changes from changelog to GitLab release description.


## [1.0.1] - 2023-12-10

### Removed
- `terraform-registry` component: Remove input validation with regex, since it's not yet released.


## [1.0.0] - 2023-12-09
_Initial release._


[2.0.0]: https://gitlab.com/vaz-projects/gitlab/-/releases/2.0.0
[1.3.0]: https://gitlab.com/vaz-projects/gitlab/-/releases/1.3.0
[1.2.0]: https://gitlab.com/vaz-projects/gitlab/-/releases/1.2.0
[1.1.1]: https://gitlab.com/vaz-projects/gitlab/-/releases/1.1.1
[1.1.0]: https://gitlab.com/vaz-projects/gitlab/-/releases/1.1.0
[1.0.1]: https://gitlab.com/vaz-projects/gitlab/-/releases/1.0.1
[1.0.0]: https://gitlab.com/vaz-projects/gitlab/-/releases/1.0.0