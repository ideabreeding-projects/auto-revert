#!/bin/bash

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

URI=https://api.github.com
API_HEADER="X-GitHub-Api-Version: 2022-11-28"
AUTH_HEADER="Authorization: Bearer $GITHUB_TOKEN"

commit_resp=$(curl -s -H "$AUTH_HEADER" -H "$API_HEADER" "$URI/repos/$REPO_FULLNAME/commits/main")

CURRENT_SHA=$(echo "$commit_resp" | jq -r .sha)

PARENT_SHA=$(echo "$commit_resp" | jq -r .parents.[0].sha)

git config --global --add safe.directory /github/workspace

git config --global user.email "hyseo@ymtech.co.kr"

git config --global user.name "hyseo492"

git fetch --depth 5

git reset --hard "$PARENT_SHA"

git push -f origin main
