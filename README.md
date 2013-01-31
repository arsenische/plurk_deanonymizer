Setup
-----

    heroku apps:create plurk-deanonymizer
    heroku config:set PLURK_OAUTH_CONSUMER_KEY=<consumer key> PLURK_OAUTH_CONSUMER_SECRET=<consumer secret> PLURK_OAUTH_CALLBACK_URL=http://plurk-deanonymizer.herokuapp.com/deanonymize
    git push heroku master