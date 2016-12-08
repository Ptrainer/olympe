FROM ubuntu

RUN apt-get update -qq && apt-get install -yqq \
    wget \
    curl \
    sudo \
    postgresql-client

RUN wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

RUN apt-get upgrade -yqq heroku-toolbelt
RUN apt-get clean
