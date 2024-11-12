#!/bin/bash

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

git config --global --add safe.directory /github/workspace

git config --global user.email "hyseo@ymtech.co.kr"

git config --global user.name "hyseo492"

git revert HEAD

git push -f origin main
