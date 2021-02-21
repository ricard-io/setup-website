# Containerization and CI CD

### What's in this release

* A Docker-Compose which allows building and running locally the Docker image, the localwebsite URL which can be configured with the `HUGO_BASE_URL` in the `.env` file.
* The Circle CI Pipeline deploys the website to Heroku. The `.heroku.env` file configures the container image build, for the container image to be deployed to heroku.
* The Circle CI Pipeline requires initializing secrets into secrethub, as documented in https://github.com/1718-io/propositions-relatives-au-ric/tree/0.0.2/pipeline/secrets

### How to's

* To deploy a new version of the website, jsut make a git flow release, using pure semver, and the Circle CI Pipelien will process the deployment

* In this version, the full example content is ready to serve with the hugo dev server, like this :

```bash
git clone git@github.com:gravitee-lab/propositions-relatives-au-ric.git ~/propositions-relatives-au-ric
cd ~/propositions-relatives-au-ric
git checkout "0.0.0"
export COMMIT_MESSAGE="feat.(${FEATURE_ALIAS}): adding build and run with https://github.com/gravitee-io/gravitee-docs/blob/master/Dockerfile "
hugo serve --watch -b http://127.0.0.1:1313/
```
* to run this, you must have installed on yur machine :
  * Hugo extended at least version `0.78.2` version,
  * golang version `1.14.4`,
 *  see `README.md` for full installations instructions of those two on Debian GNU/Linux
