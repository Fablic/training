FROM ruby:3.0.2

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
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - 
# 0915.下のコードでどうしてもこけるので一旦外して、nodeは手動でインストしてみる
#RUN apt-get install -y nodejs


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

# --以下は自前で追記してみる
#add a script tobe executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
# EXPOSE 3000
