FROM ruby:2.6
ENV NODE_VERSION 20
ENV DOCKER_DEFAULT_PLATFORM=linux/amd64

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

RUN apt-get update && apt-get install -y unzip && \
    CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver && \
    chmod 755 ~/chromedriver && \
    mv ~/chromedriver /usr/bin/chromedriver && \
    sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

# node install
RUN curl -SL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get -y remove nodejs-doc \
    && apt-get install -y nodejs

# yarn install
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

ENV APP_ROOT /myapp
RUN mkdir /$APP_ROOT
WORKDIR /$APP_ROOT

COPY Gemfile /$APP_ROOT/Gemfile
COPY Gemfile.lock /$APP_ROOT/Gemfile.lock

ENV BUNDLE_PATH=/usr/local/bundle
RUN bundle install

COPY . /$APP_ROOT
