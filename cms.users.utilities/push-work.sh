#!/bin/bash

export CURR_FOLDER=$(pwd)
export CURR_GIT_BRANCH_NAME=$(git branch -a | grep '*' | awk '{print $2}')

if [ "${CURR_GIT_BRANCH_NAME}" == "master" ]; then
  echo "You are on the [master] git branch, maybe by accident. You should not, ever git push to [master] git branch."
else
  if [ "${CURR_GIT_BRANCH_NAME}" == "master" ]; then
    echo "You are on the [develop] git branch, maybe by accident. You should not, ever git push to [develop] git branch."
    if [ -f ./cms.users.utilities/start-content-work.sh ]; then
      echo "run the [./cms.users.utilities/start-content-work.sh] command to setup to work on [ricard-io] website content"
    else
      echo "In the current folder [${CURR_FOLDER}] the [./cms.users.utilities/start-content-work.sh] does not even exists : just restart a new worspace from zero, you are lost here."
    fi;
  fi;
fi;

export COMMIT_MESSAGE=${COMMIT_MESSAGE:-"content: pushing work to Github"}
git add --all && git commit -m "${COMMIT_MESSAGE}" && git push -u origin HEAD
