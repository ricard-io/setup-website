# +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---               HUGO BASE CONTAINER IMAGE             --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ #

ARG ALPINE_OCI_IMAGE_TAG=${ALPINE_OCI_IMAGE_TAG}
ARG GOLANG_VERSION=${GOLANG_VERSION:-1.15.6}
FROM golang:$GOLANG_VERSION-alpine$ALPINE_OCI_IMAGE_TAG AS hugo_build_base

ARG ALPINE_OCI_IMAGE_TAG=${ALPINE_OCI_IMAGE_TAG:-'latest'}

ARG GOLANG_VERSION=${GOLANG_VERSION}
ARG HUGO_VERSION=${HUGO_VERSION}
ARG HUGO_BASE_URL=${HUGO_BASE_URL}

RUN echo "GOLANG_VERSION=[${GOLANG_VERSION}] and HUGO_VERSION=[${HUGO_VERSION}] and HUGO_BASE_URL=[${HUGO_BASE_URL}]"
USER root
# [build-base] because the hugo installation requires gcc and [build-base] package contains the proper gcc
RUN apk update && apk add curl git tree tar bash build-base
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---              CHECKING GOLANG VERSION                --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #

RUN export PATH=$PATH:/usr/local/go/bin && go version

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---                   INSTALLING HUGO                   --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #

COPY heroku.alpine.hugo-extended.setup.sh .
RUN chmod +x ./heroku.alpine.hugo-extended.setup.sh && ./heroku.alpine.hugo-extended.setup.sh
RUN echo "Is Hugo properly installed ?"
RUN export PATH=$PATH:/usr/local/go/bin && hugo version && hugo env

# +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---               HUGO BUILD CONTAINER IMAGE            --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ #

FROM hugo_build_base AS hugo_build
# FROM alpine:${ALPINE_OCI_IMAGE_TAG} AS hugo_build

ARG GIT_COMMIT_ID=${GIT_COMMIT_ID}
ARG CICD_BUILD_ID=${CICD_BUILD_ID}
# export CICD_BUILD_TIMESTAMP=$(date --rfc-3339 seconds)
ARG CICD_BUILD_TIMESTAMP=${CICD_BUILD_TIMESTAMP}
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---                  HUGO BUILD                         --- #
# ---         into [/usr/local/apache2/htdocs]            --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
LABEL io.ricard-io.oci.base.image="golang:${GOLANG_VERSION}-alpine${ALPINE_OCI_IMAGE_TAG}"
LABEL io.ricard-io.golang.version="${GOLANG_VERSION}"
LABEL io.ricard-io.hugo.version="${HUGO_VERSION}"
LABEL io.ricard-io.git.commit.id="${GIT_COMMIT_ID}"
LABEL io.ricard-io.cicd.build.id="${CICD_BUILD_ID}"
LABEL io.ricard-io.cicd.build.timestamp="${CICD_BUILD_TIMESTAMP}"
LABEL io.ricard-io.website="https://ricard-io.herokuapp.com"
LABEL io.ricard-io.github.org="https://github.com/ricard-io"
LABEL io.ricard-io.author="Jean-Baptiste Lasselle <jean.baptiste.ricard.io@gmail.com>"
LABEL io.ricard-io.maintainer="Jean-Baptiste Lasselle <jean.baptiste.ricard.io@gmail.com>"

RUN mkdir -p /ricard-io.io/hugo/src/
# COPY . /ricard-io.io/hugo/src/
# COPY .git /ricard-io.io/hugo/src/
RUN ls -allh /ricard-io.io/hugo/src/

WORKDIR /ricard-io.io/hugo/src/
EXPOSE 1313
# RUN export PATH=$PATH:/usr/local/go/bin && cd /ricard-io.io/hugo/src/ && hugo -b "${HUGO_BASE_URL}"
# RUN echo 'export PATH=$PATH:/usr/local/go/bin' > /ricard-io.io/entrypoint.sh
# RUN chmod +x /ricard-io.io/entrypoint.sh
# ENTRYPOINT [ "/ricard-io.io/entrypoint.sh" ]
