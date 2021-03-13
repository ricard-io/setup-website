# Quelques porpositions quant au RIC

## Dev

```bash
docker pull alpine
export TEMP_SECRETS=$(mktemp -t temp_secrets_XXXXXX) || exit
docker run -itd --name devops_bubble sh
docker exec -it devops_bubble sh -c "apk update && apk add curl git tree tar bash"
export TEMP_OPS=$(mktemp -t ops_tmp_XXXXXX) || exit
cat << EOF > ${TEMP_OPS}/install-secrethub-cli.sh
#!/bin/bash

# ---
# install secrethub with a bash shell script
# user executing this script must be root

# eg : https://github.com/secrethub/secrethub-cli/releases/download/v0.41.2/secrethub-v0.41.2-darwin-amd64.tar.gz
export SECRETHUB_CLI_VERSION=0.41.2
# Use [export SECRETHUB_OS=linux] instead of [export SECRETHUB_OS=darwin] for
# most of GNU/Linux Distribution that is not Mac OS.
export SECRETHUB_OS=darwin
export SECRETHUB_CPU_ARCH=amd64

curl -LO https://github.com/secrethub/secrethub-cli/releases/download/v\${SECRETHUB_CLI_VERSION}/secrethub-v\${SECRETHUB_CLI_VERSION}-\${SECRETHUB_OS}-\${SECRETHUB_CPU_ARCH}.tar.gz

mkdir -p /usr/local/bin
mkdir -p /usr/local/secrethub/\${SECRETHUB_CLI_VERSION}
tar -C /usr/local/secrethub/\${SECRETHUB_CLI_VERSION} -xzf secrethub-v\${SECRETHUB_CLI_VERSION}-\${SECRETHUB_OS}-\${SECRETHUB_CPU_ARCH}.tar.gz

ln -s /usr/local/secrethub/\${SECRETHUB_CLI_VERSION}/bin/secrethub /usr/local/bin/secrethub

secrethub --version
EOF

docker cp ${TEMP_OPS}/install-secrethub-cli.sh devops_bubble:/root

docker exec -it devops_bubble sh -c "chmod +x /root/install-secrethub-cli.sh"
docker exec -it devops_bubble sh -c "/root/install-secrethub-cli.sh"

# ---
# Now go into the container and create the serethub account for the https://github.com/ricard-io Org



```

* helper :

```bash
ls -allh ${HOME}/.secrethub


export SH_USERNAME="jb_ricard"
export SH_FULL_USERNAME="jbl_ricard"
export SH_USER_EMAIL="jean.baptiste.ricard.io@gmail.com"
export SH_ORG="ricard-io"
export SH_ORG_DESC="Secrethub Org for the https://github.com/"
secrethub signup --username="${SH_USERNAME}" --full-name="${SH_FULL_USERNAME}" --email="${SH_USER_EMAIL}" --org="${SH_ORG}" --org-description="${SH_ORG_DESC}"

ls -allh ${HOME}/.secrethub

cat ${HOME}/.secrethub/credential
```

* mini-man :

```bash
$ secrethub signup --help

usage: secrethub signup [<flags>]

Create a free personal developer account.

Flags:
      --username=USERNAME    The username you would like to use on SecretHub. ($SECRETHUB_SIGNUP_USERNAME)
      --full-name=FULL-NAME  Your full name. ($SECRETHUB_SIGNUP_FULL_NAME)
      --email=EMAIL          Your (work) email address we will use for all correspondence. ($SECRETHUB_SIGNUP_EMAIL)
      --org=ORG              The name of your organization. ($SECRETHUB_SIGNUP_ORG)
      --org-description=ORG-DESCRIPTION
                             A description (max 144 chars) for your organization so others will recognize it. ($SECRETHUB_SIGNUP_ORG_DESCRIPTION)
  -f, --force                Ignore confirmation and fail instead of prompt for missing arguments. ($SECRETHUB_SIGNUP_FORCE)
```
