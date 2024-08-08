# syntax = docker/dockerfile:1.9.0

FROM alpine:3.18

# Tools used by several jobs.
RUN apk add --no-cache fish curl

# For GitLab release job.
ARG bin=/usr/local/bin/
RUN <<EOF
	wget https://gitlab.com/gitlab-org/release-cli/-/releases/v0.16.0/downloads/bin/release-cli-linux-amd64 -O $bin/release-cli
	chmod +x $bin/release-cli
EOF
COPY --link scripts/parse-changelog.fish $bin/

ENTRYPOINT [ "/bin/sh", "-c" ]