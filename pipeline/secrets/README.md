# Secrets inventory inventory

For secrets operations, see https://github.com/ricard-io/secrets-management

## Secrets tree

```bash
$ secrethub tree "${SECRETHUB_ORG}/${SECRETHUB_REPO}"
cicd/
└── ricard_io_bot/
    ├── circleci/
    │   └── secrethub-svc-account/
    │       └── token
    ├── email/
    │   ├── address
    │   ├── backup_email
    │   └── password
    ├── heroku/
    │   ├── api-token
    │   ├── user-name
    │   └── user-pwd
    └── oci/
        └── quay-io/
            ├── user-name
            └── user-pwd
```

```bash
export SECRETHUB_ORG="ricard-io"
export SECRETHUB_REPO="cicd"

secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/ricard_io_bot/email/address"
secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/ricard_io_bot/email/password"
secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/ricard_io_bot/email/backup_email"
# ---
# Circle CI  Service Account for the [ricard-io-cicd] Cirlce CI context for
# the https://github.com/ricard-io Circle CI Org
secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/ricard_io_bot/circleci/secrethub-svc-account/token"
secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/ricard_io_bot/oci/quay-io/user-name"
secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/ricard_io_bot/oci/quay-io/user-pwd"
# ---
# Heroku secrets
secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/ricard_io_bot/heroku/user-name"
secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/ricard_io_bot/heroku/user-pwd"
secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/ricard_io_bot/heroku/api-token"

```
