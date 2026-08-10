FROM node:20.19-bookworm-slim AS node_runtime

FROM ruby:3.3.6
ENV LANG=en_US.UTF-8

COPY --from=node_runtime /usr/local/bin/node /usr/local/bin/node
COPY --from=node_runtime /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm

RUN apt-get update -qq && \
    apt-get install -y postgresql-client libjemalloc2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man && \
    ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx && \
    npm install -g yarn

WORKDIR /app
COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN bundle install
RUN yarn install

COPY . ./
RUN bundle exec hanami assets compile

ENV LD_PRELOAD="libjemalloc.so.2"

EXPOSE 2300
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
