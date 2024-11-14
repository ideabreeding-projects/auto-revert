#!/bin/bash

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

echo "REPO_FULLNAME=$REPO_FULLNAME"

URI=https://api.github.com
API_HEADER="X-GitHub-Api-Version: 2022-11-28"
AUTH_HEADER="Authorization: Bearer $GITHUB_TOKEN"

echo "API = $URI/repos/$REPO_PULLNAME/commits/main"

commit_resp=$(curl -s -H "$AUTH_HEADER" -H "$API_HEADER" "$URI/repos/$REPO_PULLNAME/commits/main")

echo "COMMIT_RESP=$commit_resp"

CURRENT_SHA=$(echo "$commit_resp" | jq -r .sha)

echo "PARENT_SHA=$CURRENT_SHA"

git config --global --add safe.directory /github/workspace

git config --global user.email "hyseo@ymtech.co.kr"

git config --global user.name "hyseo492"

git revert --no-edit $CURRENT_SHA

git push origin main -f
