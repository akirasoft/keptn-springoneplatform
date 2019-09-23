#!/bin/bash
export GITHUB_USER=$(cat creds.json | jq -r '."githubUserName"')
export GITHUB_TOKEN=$(cat creds.json | jq -r '."githubPersonalAccessToken"')
export GITHUB_ORG=$(cat creds.json | jq -r '."githubOrg"')
export GITHUB_REPO="sockshop"
/usr/bin/hub delete $GITHUB_ORG/$GITHUB_REPO