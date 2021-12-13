FROM ruby:2.5.7

RUN apt-get update && \
    apt-get install -y default-mysql-client

WORKDIR /app
COPY . .
RUN bundle install

CMD ["rails", "server", "-b", "0.0.0.0"]
