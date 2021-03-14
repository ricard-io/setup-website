# Un Ricard sinon rien

This repository versions the webiste of the "Un Ricard sinon rien" work group.

"Un Ricard sinon rien" is a French work group. We never the less welcome anyone, from any country, interested in taking part of our work.

As of software, we work exclusively with open source technologies, and all software that we make available are licensed under the GNU GPLv3 Affero License :
* to make everyone sure that when collaborating with our work group, there is, and will never, ever be any money related stake.
* so that any citizen can be sure that no individual, organization or company, will ever be able to require any payment, for the use of the software we publish

as a continued spirit of the work of Richard Stallman

This work group focuses on two subjects :
* providing citizens with a software which, allows them to spin up and manage the entire lifecycle of a vote :
  * with full sovereignty
  * with a level of security and reliability equal or greater, than the votes / elections organized and managed by the state of their own country.
* building something new, between society as a whole, and the member of that society, which are information technology professionals, as a corporation.


We chose the https://gohugo.io technology for our website :
* like many major open source projects like the Kubernetes Project.
* because it is a Git based Headless CMS : and therefore it is particularly suitable for collaboration


## Dev environment

To work on this project, you will need on your machine, to have intalled :

* git and the git flow AVH edition
* Golang version `1.15.6`
* hugo "extended", version `0.78.2`

Below you will find recipes to install Golang and hugo "extended" on a GNU/Linux machine.

### Docker-Compose

```bash
export WHERE_I_WORK=$(mktemp -d -t ricard-io-website_XXXXXX)

git clone git@github.com:ricard-io/setup-website.git "${WHERE_I_WORK}"
cd "${WHERE_I_WORK}"

export FEATURE_ALIAS='dev-compose'

git checkout "feature/${FEATURE_ALIAS}"

docker-compose up -d hugo_dev


```

### Debian and GNU / Linux : bare machine

#### Basic workflow

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

# if [ -d "${WHERE_I_WORK}" ]; then
  # rm -fr "${WHERE_I_WORK}"
# fi;

git clone git@github.com:ricard-io/setup-website.git "${WHERE_I_WORK}"
cd "${WHERE_I_WORK}"

export FEATURE_ALIAS='ric-interne'
# git flow feature start ${FEATURE_ALIAS} && git push -u origin --all
# git checkout "feature/${FEATURE_ALIAS}"
export COMMIT_MESSAGE="feat.(${FEATURE_ALIAS}): adding build and run with https://github.com/gravitee-io/gravitee-docs/blob/master/Dockerfile "
# git add --all && git commit -m "${COMMIT_MESSAGE}" && git push -u origin HEAD
atom .

```


* run the hugo dev server, in the same folder, in antoher shell session, in parallel :

```bash
# go must be installed
export PATH=$PATH:/usr/local/go/bin
hugo serve --watch -b http://127.0.0.1:1313/
```

#### Installations on the dev machine


* Intall hugo extended version (some hugo themes require that, and the hugo compose theme requries it, to build sass css resources) :

```bash
export PATH=$PATH:/usr/local/go/bin
# check you hugo version with [hugo version] command
# My hugonon extended installed  version was [v0.78.2] so I set HUGO_VERSION to 0.78.2 (without the v, to be pure semver)
# Set the HUGO_VERSION to the version of your hugo installation
export HUGO_VERSION=0.78.2
echo "HUGO_VERSION=[${HUGO_VERSION}]"

mkdir -p ~/.hugo.extended/v${HUGO_VERSION}
git clone https://github.com/gohugoio/hugo.git ~/.hugo.extended/v${HUGO_VERSION}
cd ~/.hugo.extended/v${HUGO_VERSION}
git checkout "v${HUGO_VERSION}"
go install --tags extended
```

* Install the Golang platform

```bash
# Choose the version of golang you want at [https://github.com/golang/go/releases]
export GOVERSION=1.15.6
export GOOS=linux
export GO_CPU_ARCH=amd64

export DWLD_URI=https://golang.org/dl/go${GOVERSION}.${GOOS}-${GO_CPU_ARCH}.tar.gz

curl -LO https://golang.org/dl/go${GOVERSION}.${GOOS}-${GO_CPU_ARCH}.tar.gz

mkdir -p /usr/local/golang/${GOVERSION}/${GOOS}/${GO_CPU_ARCH}

# ---
# delete any previous installation

if [ -f /usr/local/go ]; then
 sudo rm -fr /usr/local/go
fi;

if [ -f /usr/local/golang/${GOVERSION}/${GOOS}/${GO_CPU_ARCH}/go ]; then
 sudo rm -fr /usr/local/golang/${GOVERSION}/${GOOS}/${GO_CPU_ARCH}/go
fi;

sudo tar -C /usr/local -xzf go${GOVERSION}.${GOOS}-${GO_CPU_ARCH}.tar.gz

# [/usr/local/golang/${GOVERSION}/${GOOS}/${GO_CPU_ARCH}/go] is a folder, executables are in [/usr/local/golang/${GOVERSION}/${GOOS}/${GO_CPU_ARCH}/go/bin]
sudo ln -s /usr/local/golang/${GOVERSION}/${GOOS}/${GO_CPU_ARCH}/go /usr/local/go

unset GOVERSION
unset GOOS
unset GO_CPU_ARCH

export PATH=$PATH:/usr/local/go/bin
go version
```


### CORS configuration of the http server

The Apache 2 HTTP Server "`httpd`" is used to deploy the website to Heroku. An `httpd.conf` configuration file was added to configure CORS to allow all origins :

```ini
#
# Apparemment, d'après [https://enable-cors.org/server_apache.html] :
#
Header set Access-Control-Allow-Origin "*"
```

### Docker images and the GIT COMMIT ID

* To retrieve the GIT COMMIT ID from the latest docker image : `docker inspect --format '{{ index .Config.Labels "git.commit.id"}}' "quay.io/ricard-io/une_proposition:stable-latest"`
* And to find the same commit on a git repo :

```bash
# ---
#
git log --abbrev-commit --pretty=oneline
# ---
# And from the graph displayed here :
git log --graph --abbrev-commit --decorate --date=relative  --format=format:'%C(bold red)%h%C(reset)%C(bold green)%d%C(reset) %C(bold blue)%ai %C(reset) %C(yellow)%ar%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all

# ---
# also
git log --graph --decorate --pretty=oneline --abbrev-commit --all
```
