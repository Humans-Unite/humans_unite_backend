FROM ruby:3.2

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the full app
COPY . .

# Precompile assets (if needed)
RUN bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Start the app using Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
