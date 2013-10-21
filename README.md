It allows to deanonymize your friends' if their anonymous plurk receives sufficient amount of comments.

Setup
-----

    heroku apps:create plurk-deanonymizer
    heroku config:set PLURK_OAUTH_CONSUMER_KEY=<consumer key> PLURK_OAUTH_CONSUMER_SECRET=<consumer secret>
    git push heroku master

