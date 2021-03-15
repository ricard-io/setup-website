#!/bin/bash

export WHERE_I_WORK=$(mktemp -d -t ricard-io-website_XXXXXX)

git clone git@github.com:ricard-io/setup-website.git "${WHERE_I_WORK}"
cd "${WHERE_I_WORK}"


export QUESTION_IS="What content are you going to edit ? (answer with just one short word, no spaces, no special characters, you can use '_' and '-')"
read -p "${QUESTION_IS} \n" CONTENT_ALIAS_ANS

export CONTENT_ALIAS="${CONTENT_ALIAS_ANS}"

export GIT_WORK_BRANCH_NAME=${GIT_WORK_BRANCH_NAME:-"content/${CONTENT_ALIAS_ANS}_${RANDOM}"}

git checkout develop

export GIT_WORK_BRANCH_NAME="feature/dev-compose"
export GIT_BRANCH_EXIST=$(git branch -a | grep "${GIT_WORK_BRANCH_NAME}" | grep -v 'remotes')
echo "GIT_BRANCH_EXIST=[${GIT_BRANCH_EXIST}]"

if [ "x${GIT_BRANCH_EXIST}" == "x" ]; then
  echo "No, the [${GIT_WORK_BRANCH_NAME}] git branch does not exist"
  git checkout -b "${GIT_WORK_BRANCH_NAME}" && git push -u origin HEAD
else
  echo "Yes, the [${GIT_WORK_BRANCH_NAME}] git branch exists"
  git checkout "${GIT_WORK_BRANCH_NAME}"
fi;

echo "# ----------------------------------------------------------------- #"
echo "# ----------------------------------------------------------------- #"
echo "# ---------- Now you can open your favorite editor in"
echo "# ---------- this folder : "
export CURR_FOLDER=$(pwd)
echo "# ---------- [${CURR_FOLDER}]"
echo "# ----------------------------------------------------------------- #"
echo "# ----------------------------------------------------------------- #"
