FROM ruby:3.2.1

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# node install
RUN curl -SL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get -y remove nodejs-doc \
    && apt-get install -y nodejs

CMD ["rails", "server", "-b", "0.0.0.0"]
