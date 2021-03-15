#!/bin/bash

# if you are admin you will have access to the
export SECRETHUB_ORG="ricard-io"
export SECRETHUB_REPO="admin"
echo "The [${SECRETHUB_ORG}/${SECRETHUB_REPO}] was not created in the https://github.com/ricard-io/secrets-management.git repo"
exit 7
# ---
# command belmow will fail if you were not
# given access to the admin repo : if you are not a super admin @ ricard-io
secrethub tree "${SECRETHUB_ORG}/${SECRETHUB_REPO}"
export CCI_TOKEN=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/circleci/api/personal/token")


export OCI_IMAGE_TAG_TO_DELETE=${OCI_IMAGE_TAG_TO_DELETE:-"content_jbltest1-cms"}
export ORG_NAME="ricard-io"
export REPO_NAME="setup-website"
export BRANCH="master"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"admin_task\": \"delete_oci_image\",
        \"oci_image_tag\": \"${OCI_IMAGE_TAG_TO_DELETE}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
