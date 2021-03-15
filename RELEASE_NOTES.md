# Containerization and CI CD

## What's in this release

* A Docker-Compose which allows building and running locally thye website at http://127.0.0.1:1313 , and in watch mode : if you change a file, the change is immediately rendered into the browser.
* The Circle CI Pipeline deploys the website to Heroku at https://ricard-io.herokuapp.com . The `.heroku.env` file configures the container image build, for the container image to be deployed to heroku.
* The Circle CI Pipeline requires initializing secrets into secrethub, as documented in https://github.com/ricard-io/secrets-management

## How to's

### Content management


You need installed on your machine :
* `docker`, and `docker-compose`
* `git`
* and we strongly recommend the `git-flow AVH Edition` plugin


#### GNU/Linux and MacOS

* Open a terminal shell session, type the `bash` command, hit the Return keyboard key, and then run :

```bash
export WHERE_I_WORK=$(mktemp -d -t ricard-io-website_XXXXXX)

git clone git@github.com:ricard-io/setup-website.git "${WHERE_I_WORK}"
cd "${WHERE_I_WORK}"

export DESIRED_VERSION="0.0.1"

git checkout "${DESIRED_VERSION}"

docker-compose up -d
```

#### GNU/Linux and MacOS

* Open a terminal shell session, type the `bash` command, hit the Return keyboard key, and then run :

```bash

git clone git@github.com:ricard-io/setup-website.git ./ricard-io-website
cd ./ricard-io-website

export DESIRED_VERSION="0.0.1"

git checkout "${DESIRED_VERSION}"

docker-compose up -d
```
