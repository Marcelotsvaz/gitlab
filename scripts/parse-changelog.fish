#! /usr/bin/env fish

argparse --min-args 1 --max-args 1 -- $argv
or exit

set releaseVersion $(string escape --style regex $argv[1])
set changelogFile changelog.md

set header '^## \['$releaseVersion'\].*\n{1,2}'
set content '((?s).+?)'
set footer '\n\n\n'

test -e $changelogFile
or echo "Could not find changelog file '$changelogFile'." >&2 && exit 1

string match --regex --groups-only "(?m)$header$content$footer" $(cat $changelogFile | string split0)
or echo 'Could not parse changelog.md.' >&2 && exit 1