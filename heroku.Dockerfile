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
# we need extended, and nodejs for sass!
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
# ---                  HUGO BUILD             --- #
# ---         into [/usr/local/apache2/htdocs]            --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #

RUN mkdir -p /ricard-io.io/hugo/src/
COPY . /ricard-io.io/hugo/src/
COPY .git /ricard-io.io/hugo/src/
RUN ls -allh /ricard-io.io/hugo/src/
RUN export PATH=$PATH:/usr/local/go/bin && cd /ricard-io.io/hugo/src/ && hugo -b "${HUGO_BASE_URL}"

# +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---               PUBLISHED CONTAINER IMAGE             --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ #


FROM httpd:${HTTPD_OCI_IMAGE_TAG} AS release

ARG HTTPD_OCI_IMAGE_TAG=${HTTPD_OCI_IMAGE_TAG}
ARG GIT_COMMIT_ID=${GIT_COMMIT_ID}
ARG CICD_BUILD_ID=${CICD_BUILD_ID}
# export CICD_BUILD_TIMESTAMP=$(date --rfc-3339 seconds)
ARG CICD_BUILD_TIMESTAMP=${CICD_BUILD_TIMESTAMP}


LABEL io.ricard-io.cicd.build.id="${CICD_BUILD_ID}"
LABEL io.ricard-io.cicd.build.timestamp="${CICD_BUILD_TIMESTAMP}"
LABEL io.ricard-io.git.commit.id="${GIT_COMMIT_ID}"
LABEL io.ricard-io.daymood="https://www.youtube.com/watch?v=v-JsqKlVVGk&list=RDv-JsqKlVVGk"
LABEL io.ricard-io.oci.base.image="httpd:${HTTPD_OCI_IMAGE_TAG}"
LABEL io.ricard-io.golang.version="${GOLANG_VERSION}"
LABEL io.ricard-io.hugo.version="${HUGO_VERSION}"
LABEL io.ricard-io.website="https://ricard-io.herokuapp.com"
LABEL io.ricard-io.github.org="https://github.com/ricard-io"
LABEL io.ricard-io.author="Jean-Baptiste Lasselle <jean.baptiste.ricard.io@gmail.com>"
LABEL io.ricard-io.maintainer="Jean-Baptiste Lasselle <jean.baptiste.ricard.io@gmail.com>"

# --- HEROKU ENV.
#
# https://help.heroku.com/PPBPA231/how-do-i-use-the-port-environment-variable-in-container-based-apps
#
# In a word :
# Heroku platform will assign a value to the PORT variable, and
# do the network setup with reverse proxying. So Basically I just haveto know that
# the PORT environment variable is there where the network will happen, where the network traffic will travel : I can listen on that port if I want, for example
# At any rate, I should NOT EVER
# EXPOSE $PORT

# Okay, so my Apache HTTP Server should listen on port number defined by $PORT
ARG PORT
ENV PORT=$PORT


USER root
RUN mkdir -p /ricard-io.io
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---         INSTALLING RESULT OF HUGO BUILD             --- #
# ---         into [/usr/local/apache2/htdocs]            --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #

RUN rm -fr /usr/local/apache2/htdocs
RUN mkdir -p /usr/local/apache2/htdocs
RUN mkdir -p /ricard-io.io/retrieved_hugo_build
COPY --from=hugo_build /ricard-io.io/hugo/src/public /ricard-io.io/retrieved_hugo_build
#   fRench do it, Let(')s do it, Let's...
RUN cp -fR /ricard-io.io/retrieved_hugo_build/* /usr/local/apache2/htdocs

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# ---  APACHE CONF FILE AND RUN SCRIPT (with healthcheck) --- #
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# This [httpd.conf] is customized with CORS rules
RUN rm -f /usr/local/apache2/conf/httpd.conf
COPY httpd.conf /usr/local/apache2/conf

COPY heroku.apache.start.sh /ricard-io.io
COPY heroku.container.healthcheck.sh /ricard-io.io
RUN chmod +x /ricard-io.io/*.sh

#
# healthcheck:
#   test: ["CMD", "/ricard-io.io/website.healthcheck.sh"]
#   interval: 5s
#   timeout: 10s
#   retries: 30
#   start_period: 60s
#

ENTRYPOINT ["/ricard-io.io/heroku.apache.start.sh"]
