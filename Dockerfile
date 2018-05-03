# This sets up a docker container suitable for use with Travis CI

FROM ruby:2.3.7-slim-stretch

RUN apt-get update
RUN apt-get -y install build-essential libxml2-dev git postgresql-client libpq-dev ssh emacs24-nox
RUN useradd -ms /bin/bash danbooru -u 1000
RUN mkdir /app
COPY . /app
RUN chown -R danbooru:danbooru /app
EXPOSE 3000
USER danbooru
RUN echo 'gem: --no-document' > ~/.gemrc
RUN gem install bundler
WORKDIR /app
RUN bundle install
