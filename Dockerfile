FROM ruby:3.1
ENV BUNDLER_VERSION=2.3.10
ENV APP_HOME=/app
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v $BUNDLER_VERSION && bundle install
COPY . ./
RUN bundle exec rake assets:precompile
EXPOSE 2300
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
