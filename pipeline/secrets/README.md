# CI CD Pipeline Secrets

### Circle CI Org context

```bash
export SECRETHUB_ORG="ric1718"
export SECRETHUB_REPO="cicd"
secrethub org init -f --name="${SECRETHUB_ORG}" --description="The secrethub org to manage secrets for anything related to https://github.com/1718-io/propositions-relatives-au-ric"
secrethub repo init "${SECRETHUB_ORG}/${SECRETHUB_REPO}"

# --- #
# create a service account
secrethub service init "${SECRETHUB_ORG}/${SECRETHUB_REPO}" --description "Circle CI  Service Account for the [riccarl-cicd] Cirlce CI context for the https://github.com/1718-io/propositions-relatives-au-ric Circle CI Pipeline" --permission read | tee ./.the-created.service.token
secrethub service ls "${SECRETHUB_ORG}/${SECRETHUB_REPO}"
echo "Beware : you will see the service token only once, then you will not ever be able to see it again, don'tloose it (or create another)"
# --- #
# and give the service accoutn access to all directories and secrets in the given repo, with the option :
# --- #
# finally, in Circle CI, you created a 'riccarl-cicd' context in the [https://github.com/1718-io] Github Org
# and in that 'riccarl-cicd' Circle CI context, you set the 'SECRETHUB_CREDENTIAL' env. var. with
# value the token of the service account you just created


# saving service account token
secrethub mkdir --parents "${SECRETHUB_ORG}/${SECRETHUB_REPO}/carlbot/circleci/secrethub-svc-account"
cat ./.the-created.service.token | secrethub write "${SECRETHUB_ORG}/${SECRETHUB_REPO}/carlbot/circleci/secrethub-svc-account/token"
```

### Heroku secrets

* For the https://ric-carl.herokuapp.com/ website, the heroku API token

```bash
export SECRETHUB_ORG="ric1718"
export SECRETHUB_REPO="cicd"
secrethub org init -f --name="${SECRETHUB_ORG}" --description="The secrethub org to manage secrets for anything related to https://github.com/1718-io/propositions-relatives-au-ric"
secrethub repo init "${SECRETHUB_ORG}/${SECRETHUB_REPO}"

# --- #
# for the DEV CI CD WorkFlow of
# the ccc website
secrethub mkdir --parents "${SECRETHUB_ORG}/${SECRETHUB_REPO}/carlbot/heroku/"

# --- #
# write Heroku secrets for the DEV CI CD
export HEROKU_USERNAME="jean.baptiste.lasselle@gmail.com"
export HEROKU_API_TOKEN="inyourdreams;)"

echo "${HEROKU_USERNAME}" | secrethub write "${SECRETHUB_ORG}/${SECRETHUB_REPO}/carlbot/heroku/user-name"
echo "${HEROKU_API_TOKEN}" | secrethub write "${SECRETHUB_ORG}/${SECRETHUB_REPO}/carlbot/heroku/api-token"

```

### Quay.io (Container images repository)

* For the https://ric-carl.herokuapp.com/ website, the container image definition will be stored at `quay.io/ric1718/une_proposition`

```bash
export SECRETHUB_ORG="ric1718"
export SECRETHUB_REPO="cicd"
secrethub org init -f --name="${SECRETHUB_ORG}" --description="The secrethub org to manage secrets for anything related to https://github.com/1718-io/propositions-relatives-au-ric"
secrethub repo init "${SECRETHUB_ORG}/${SECRETHUB_REPO}"

# --- #
# for the DEV CI CD WorkFlow of
# the ccc website
secrethub mkdir --parents "${SECRETHUB_ORG}/${SECRETHUB_REPO}/carlbot/oci/quay-io/"

# --- #
# write quay secrets for the DEV CI CD WorkFlow
export QUAY_USERNAME="ric1718+carl"
export QUAY_TOKEN="inyourdreams;)"

echo "${QUAY_USERNAME}" | secrethub write "${SECRETHUB_ORG}/${SECRETHUB_REPO}/carlbot/oci/quay-io/user-name"
echo "${QUAY_TOKEN}" | secrethub write "${SECRETHUB_ORG}/${SECRETHUB_REPO}/carlbot/oci/quay-io/user-pwd"

```
