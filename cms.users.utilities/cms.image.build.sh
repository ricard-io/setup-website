#!/bin/bash

source .cms.env
echo "QUAY_OCI_IMAGE_TAG=[${QUAY_OCI_IMAGE_TAG}]"
export GIT_COMMIT_ID=$(git rev-parse --short HEAD)
export CICD_BUILD_ID=314129
# export CICD_BUILD_TIMESTAMP=$(date --rfc-3339 seconds)
export CICD_BUILD_TIMESTAMP=$(date)
echo "GIT_COMMIT_ID=${GIT_COMMIT_ID}" | tee -a .cms.env
echo "CICD_BUILD_ID=${CICD_BUILD_ID}" | tee -a .cms.env
echo "CICD_BUILD_TIMESTAMP='${CICD_BUILD_TIMESTAMP}'" | tee -a .cms.env
source .cms.env
docker-compose -f ./docker-compose.cms.build.yml build hugo_cms
# and now [quay.io/ricardio/website:${QUAY_OCI_IMAGE_TAG}] should exists among [docker images]
docker images
