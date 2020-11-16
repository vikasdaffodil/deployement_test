#!/bin/bash

# any future command that fails will exit the script
set -e

CONF=$1
APP_NAME=$2
CI_COMMIT_REF_NAME=$3
CI_COMMIT_SHA=$4

echo "$CI_COMMIT_REF_NAME $CI_COMMIT_SHA"

DEPLOY_PATH=/home/ubuntu/portal/ui
cd $DEPLOY_PATH

# git pull
git reset HEAD --hard
git pull origin $CI_COMMIT_REF_NAME
git checkout -qf $CI_COMMIT_SHA
npm ci
export NODE_OPTIONS=--max-old-space-size=8000 && ng build --configuration="$CONF"
if [ -d "build" ]
then
    rm -rf dist/
    mv build dist
    echo "Build of ${APP_NAME} succeedeed with configuration $CONF."
else
    echo "Build failed"
    exit 1
fi
