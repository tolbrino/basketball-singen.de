#!/usr/bin/env bash

set -Eeuo pipefail

echo "Starting deployment"
echo "Target: gh-pages branch"

TEMP_DIRECTORY="/tmp/__temp_static_content"
CURRENT_COMMIT=`git rev-parse HEAD`
ORIGIN_URL=`git config --get remote.origin.url`
ORIGIN_URL_WITH_CREDENTIALS=${ORIGIN_URL/https\:\/\/github.com\//git@github.com:}

echo "Compiling new static content"
rm -rf $TEMP_DIRECTORY
cp -R public $TEMP_DIRECTORY
cp .gitignore $TEMP_DIRECTORY
cp CNAME $TEMP_DIRECTORY

echo "Checking out gh-pages branch"
git checkout -B gh-pages

echo "Removing old static content"
git rm -rf .

echo "Copying newly generated static content"
cp -r $TEMP_DIRECTORY/* .
cp $TEMP_DIRECTORY/.gitignore .

echo "Pushing new content to $ORIGIN_URL"
git config user.name "Travis-CI"
git config user.email "noreply@travisci.org"

git add -A .
git commit --allow-empty -m "Regenerated static content for $CURRENT_COMMIT"
git push --force "$ORIGIN_URL_WITH_CREDENTIALS" gh-pages

echo "Cleaning up temp files"
rm -Rf $TEMP_DIRECTORY

echo "Deployed successfully."
