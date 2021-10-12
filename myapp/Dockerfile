FROM ruby:3.0.2
#FROM ruby:2.5.7
#FROM ruby:2.6.8

ENV LANG C.UTF-8
ENV NODE_VERSION 12

RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      libpq-dev \
      nodejs \
      default-mysql-client \
      jq \
      git \
      curl \
      python3 \
      less

# node install
#RUN curl -SL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
#    && apt-get install -y nodejs
RUN curl -SL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get -y remove nodejs-doc \
    && apt-get install -y nodejs

# yarn install
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn \

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash && apt-get update -qq && \
apt-get install -y build-essential libpq-dev nodejs yarn vim

# 210928 add chromeの追加
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

RUN gem install bundler

ENV APP_ROOT /myapp
RUN mkdir /$APP_ROOT
WORKDIR /$APP_ROOT

COPY Gemfile /$APP_ROOT/Gemfile
COPY Gemfile.lock /$APP_ROOT/Gemfile.lock
ENV BUNDLE_PATH=/usr/local/bundle
RUN bundle install

COPY . /$APP_ROOT
