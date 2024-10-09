FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v $BUNDLER_VERSION && bundle install
COPY . ./
RUN bundle exec rake assets:precompile
EXPOSE 2300
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
