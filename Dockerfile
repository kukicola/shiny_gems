FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN npm install -g yarn
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . ./
RUN bundle exec rake assets:precompile
EXPOSE 2300
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
