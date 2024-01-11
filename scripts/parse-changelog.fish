#! /usr/bin/env fish

argparse --min-args 1 --max-args 1 -- $argv
or exit

set changelogFile $argv[1]
set releaseVersionRegex $(string escape --style regex $CI_COMMIT_TAG)

set header '^## \['$releaseVersionRegex'\].*\n{1,2}'
set content '((?s).+?)'
set footer '\n\n\n'

string match --regex --groups-only "(?m)$header$content$footer" $(cat $changelogFile | string split0)
or echo "Could not parse '$changelogFile'." >&2 && exit 1