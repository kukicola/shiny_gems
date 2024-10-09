FROM ruby:3.2.2
ENV LANG en_US.UTF-8
RUN apt-get update -qq && \
    apt-get install -y nodejs npm postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man && \
    npm install -g yarn
WORKDIR /app
COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN bundle install
RUN yarn install
COPY . ./
RUN bundle exec hanami assets compile
EXPOSE 2300
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
