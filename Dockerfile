ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /app

RUN gem update --system --no-document && \
    gem install -N bundler

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libjemalloc2

RUN apt-get install nodejs npm -y
RUN npm install -g yarn

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

COPY Gemfile* .
RUN bundle install
RUN yarn install

COPY . .

RUN bundle exec hanami assets compile

EXPOSE 8080
CMD ["bundle", "exec", "puma", "--host", "0.0.0.0", "--port", "8080"]
