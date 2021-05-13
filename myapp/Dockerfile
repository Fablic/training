FROM ruby:2.6.7

ENV LANG C.UTF-8
ENV NODE_VERSION 12

RUN apt-get update -qq && \
    apt-get install -qq -y --no-install-recommends \
      build-essential \
      default-mysql-client \
      git \
      curl \
      python3

# Install Node and Yarn
RUN curl -SL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

WORKDIR /myapp

COPY Gemfile* package.json yarn.lock /myapp/
ENV BUNDLE_PATH=/usr/local/bundle
RUN yarn install && bundle install

COPY . /myapp/
