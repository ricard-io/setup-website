# Quelques porpositions quant au RIC

## Dev

```bash
# ---- ----------- ---- #
# ----  GIT CONFIG ---- #
# ----  ---------- ---- #

git config --global commit.gpgsign true
git config --global user.name "Jean-Baptiste-Lasselle"
git config --global user.email jean.baptiste.lasselle.pegasus@gmail.com
git config --global user.signingkey 7B19A8E1574C2883
# Now, to sign Git commits, for example inside an SSH session (where TTY is a bit different ...)
export GPG_TTY=$(tty)

git config --global --list

# will re-define the default identity in use
# https://docstore.mik.ua/orelly/networking_2ndEd/ssh/ch06_04.htm
ssh-add ~/.ssh.perso.backed/id_rsa

export GIT_SSH_COMMAND='ssh -i ~/.ssh.perso.backed/id_rsa'
ssh -Ti ~/.ssh.perso.backed/id_rsa git@github.com

# if [ -d ~/propositions-relatives-au-ric ]; then
  # rm -fr ~/propositions-relatives-au-ric
# fi;

git clone git@github.com:1718-io/propositions-relatives-au-ric.git ~/propositions-relatives-au-ric
cd ~/propositions-relatives-au-ric

export FEATURE_ALIAS='ric-interne'
git flow feature start ${FEATURE_ALIAS} && git push -u origin --all
git checkout "feature/${FEATURE_ALIAS}"
export COMMIT_MESSAGE="feat.(${FEATURE_ALIAS}): adding build and run with https://github.com/gravitee-io/gravitee-docs/blob/master/Dockerfile "
# git add --all && git commit -m "${COMMIT_MESSAGE}" && git push -u origin HEAD
atom .
hugo serve --watch -b http://127.0.0.1:1313/
```

* next:

```bash
export FEATURE_ALIAS="change-hugo-theme"
export COMMIT_MESSAGE="feat.(${FEATURE_ALIAS}) : changing hugo theme to a more adpated theme"

export FEATURE_ALIAS='premiere-redaction'
# git flow feature start ${FEATURE_ALIAS} && git push -u origin --all
# git checkout "feature/${FEATURE_ALIAS}"
export COMMIT_MESSAGE="feat.(${FEATURE_ALIAS}): une première rédaction de la proposition, origine, pourquoi ce document"

# git add --all && git commit -m "${COMMIT_MESSAGE}" && git push -u origin HEAD

export FEATURE_ALIAS="heroku-pipeline"
# git flow feature start ${FEATURE_ALIAS} && git push -u origin --all
# git checkout "feature/${FEATURE_ALIAS}"
export COMMIT_MESSAGE="feat.(${FEATURE_ALIAS}): Docker-compose and Circle CI Pipeline definition with heroku deployment"

# git add --all && git commit -m "${COMMIT_MESSAGE}" && git push -u origin HEAD

```

* run the hugo dev server, in the same folder, in antoher shell session, in parallel :

```bash
# go must be installed
export PATH=$PATH:/usr/local/go/bin
hugo serve --watch -b http://127.0.0.1:1313/
```


```bash
git clone git@github.com:1718-io/propositions-relatives-au-ric.git ~/propositions-relatives-au-ric-test
cd ~/propositions-relatives-au-ric-test

export FEATURE_ALIAS="heroku-pipeline"
git checkout "feature/${FEATURE_ALIAS}"
export GIT_COMMIT_ID=$(git rev-parse --short HEAD)
export QUAY_OCI_IMAGE_TAG=0.0.1-dev
docker-compose build hugo_dev
export QUAY_OCI_IMAGE_TAG=0.0.1-heroku
docker-compose build hugo_heroku
docker-compose up -d hugo_dev

export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0 && docker-compose build
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1 && docker-compose build

export D_BUILD_ARGS="--build-arg HTTPD_OCI_IMAGE_TAG=\"2.4\" "
export D_BUILD_ARGS="${D_BUILD_ARGS} --build-arg GOLANG_VERSION=\"1.15.6\" "
export D_BUILD_ARGS="${D_BUILD_ARGS} --build-arg HUGO_VERSION=\"0.78.2\" "
export D_BUILD_ARGS="${D_BUILD_ARGS} --build-arg HUGO_BASE_URL=\"https://ric-carl.herokuapp.com/\" "

export D_BUILD_ARGS="--build-arg HTTPD_OCI_IMAGE_TAG=2.4 "
export D_BUILD_ARGS="${D_BUILD_ARGS} --build-arg GOLANG_VERSION=1.15.6 "
export D_BUILD_ARGS="${D_BUILD_ARGS} --build-arg HUGO_VERSION=0.78.2 "
export D_BUILD_ARGS="${D_BUILD_ARGS} --build-arg HUGO_BASE_URL=https://ric-carl.herokuapp.com/"

# DOCKER_BUILDKIT=0 docker build -f heroku.Dockerfile . -t quay.io/ric1718/une_proposition:dev
# DOCKER_BUILDKIT=0 docker build ${D_BUILD_ARGS} -f heroku.Dockerfile . -t quay.io/ric1718/une_proposition:dev

# docker-compose down --rmi all && docker system prune -f --all && cd && rm -fr ~/propositions-relatives-au-ric
```

* ccc :

```bash
export DESIRED_VERSION=0.0.2
export DESIRED_VERSION=master

rm -fr ~/propositions-relatives-au-ric-test
git clone git@github.com:1718-io/propositions-relatives-au-ric.git ~/propositions-relatives-au-ric-test
cd ~/propositions-relatives-au-ric-test
git checkout "${DESIRED_VERSION}"

source .heroku.env
export QUAY_OCI_IMAGE_TAG=0.0.1-heroku
docker-compose build hugo_heroku

```
