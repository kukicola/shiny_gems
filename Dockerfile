FROM ruby:3.3.12-trixie
ENV LANG=en_US.UTF-8

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends nodejs node-corepack postgresql-client libjemalloc2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man && \
    corepack enable && \
    corepack prepare yarn@1.22.22 --activate

WORKDIR /app
COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN bundle install
RUN yarn install

COPY . ./
RUN bundle exec hanami assets compile

ENV LD_PRELOAD="libjemalloc.so.2"

EXPOSE 2300
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
