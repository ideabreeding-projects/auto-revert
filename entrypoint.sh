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

echo "CURRENT_SHA=$CURRENT_SHA"

echo "CURRENT_SHA_LENGTH=${#CURRENT_SHA}"

echo "PARENT_SHA=$PARENT_SHA"

echo "PARENT_SHA_LENGTH=${#PARENT_SHA}"

git config --global --add safe.directory /github/workspace

git config --global user.email "hyseo@ymtech.co.kr"

git config --global user.name "hyseo492"

git reset "${CURRENT_SHA}"

git commit -m 'rollback commit'

git push -f origin main
