#!/usr/bin/env bash

set -eu


cp $PTRAINER/website/website_database.yml $PTRAINER/website/ptrainer-website/config/database.yml
cp $PTRAINER/website/website_local_config.rb $PTRAINER/website/ptrainer-website/config/initializers/local_config.rb
