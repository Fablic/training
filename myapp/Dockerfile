FROM ruby:3.3
ENV NODE_VERSION 20

ENV LANG C.UTF-8

RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      libpq-dev \
      default-mysql-client \
      nodejs \
      jq \
      git \
      curl \
      python3 \
      less

# node install
RUN curl -SL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get -y remove nodejs-doc \
    && apt-get install -y nodejs

ENV APP_ROOT /myapp
RUN mkdir /$APP_ROOT
WORKDIR /$APP_ROOT

COPY Gemfile /$APP_ROOT/Gemfile
COPY Gemfile.lock /$APP_ROOT/Gemfile.lock

ENV BUNDLE_PATH=/usr/local/bundle
RUN bundle install

COPY . /$APP_ROOT
