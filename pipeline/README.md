# Circle CI Pipeline

##  Heroku Circle CI

### Initialize Heroku Git repo

```bash
git clone git@github.com:1718-io/propositions-relatives-au-ric.git ./propositions-relatives-au-ric
cd ./propositions-relatives-au-ric
export HEROKU_API_KEY=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/carlbot/heroku/api-token")
heroku auth:whoami
export HEROKU_APP_ID=ric-carl
heroku git:remote -a $HEROKU_APP_ID
```

###  Circle CI Orb

https://circleci.com/developer/orbs/orb/circleci/heroku


https://circleci.com/developer/orbs/orb/circleci/heroku



## Circle CI Org security for Orbs

You must authorize non-certified Circle CI Orbs for the Circle CI Organization, to use uncertifed Orbs (like the secrethub one) :

![authorize non-certified Circle CI Orbs](./images/circleci-uncertified-orbs.786Z.png)
