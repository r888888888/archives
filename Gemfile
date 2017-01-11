# frozen_string_literal: true
source "https://rubygems.org"

gem "aws-sdk", "~> 2"
gem "dotenv"
gem "standalone_migrations"
gem "activerecord"
gem "activesupport"
gem "pg"

group :production do
	gem "capistrano"
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'whenever'
end

group :development do
  gem 'foreman'
end