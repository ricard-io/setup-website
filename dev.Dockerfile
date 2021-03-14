# +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---               HUGO BASE CONTAINER IMAGE             --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ #

ARG ALPINE_OCI_IMAGE_TAG=${ALPINE_OCI_IMAGE_TAG}
ARG GOLANG_VERSION=${GOLANG_VERSION:-1.15.6}
ARG HTTPD_OCI_IMAGE_TAG=${HTTPD_OCI_IMAGE_TAG}
FROM golang:$GOLANG_VERSION-alpine$ALPINE_OCI_IMAGE_TAG AS hugo_build_base
# FROM alpine:${ALPINE_OCI_IMAGE_TAG} AS hugo_build

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

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---                  HUGO BUILD                         --- #
# ---         into [/usr/local/apache2/htdocs]            --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #

RUN mkdir -p /ricard-io.io/hugo/src/
# COPY . /ricard-io.io/hugo/src/
# COPY .git /ricard-io.io/hugo/src/
RUN ls -allh /ricard-io.io/hugo/src/

EXPOSE 1313
# RUN export PATH=$PATH:/usr/local/go/bin && cd /ricard-io.io/hugo/src/ && hugo -b "${HUGO_BASE_URL}"
RUN echo 'export PATH=$PATH:/usr/local/go/bin' > /ricard-io.io/entrypoint.sh
RUN chmod +x /ricard-io.io/entrypoint.sh
ENTRYPOINT [ "/ricard-io.io/entrypoint.sh" ]
