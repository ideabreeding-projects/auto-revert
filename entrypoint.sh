#!/bin/bash

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

URI=https://api.github.com
API_HEADER="X-GitHub-Api-Version: 2022-11-28"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

commit_resp=$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/$REPO_PULLNAME/commits/main")

echo "COMMIT_RESP=${commit_resp}"

PARENT_SHA=$(echo "$commit_resp" | jq -r .sha)

echo "PARENT_SHA=${PARENT_SHA}"

git config --global --add safe.directory /github/workspace

git config --global user.email "hyseo@ymtech.co.kr"

git config --global user.name "hyseo492"

git revert --no-edit ${PARENT_SHA}

git push origin main -f
