[![tip for next commit](http://tip4commit.com/projects/16.svg)](http://tip4commit.com/projects/16)

It allowed to deanonymize your friends' if their anonymous plurk received sufficient amount of comments.

But it doesn't work any more because plurk comments became anonymous too.

Plurk deanonimization can probably be done by embedding a tracking image into the comment but it requires additional development.

Setup
-----

    heroku apps:create plurk-deanonymizer
    heroku config:set PLURK_OAUTH_CONSUMER_KEY=<consumer key> PLURK_OAUTH_CONSUMER_SECRET=<consumer secret>
    git push heroku master

