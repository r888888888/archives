#!/bin/sh

# bootstraps the archives database and migrations on a
# new system

export POSTGRES_HOST=localhost
bundle exec rake db:create
bundle exec rake db:migrate