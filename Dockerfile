# Use official Ruby image
FROM ruby:3.2.1

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y curl gnupg default-mysql-client nodejs yarn build-essential libpq-dev

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler

# Copy Gemfiles first (for caching)
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy rest of the application
COPY . .

# Precompile assets
# RUN RAILS_ENV=production bundle exec rake assets:precompile

# Set environment variables
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Expose port 3000
EXPOSE 3000

# Start the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
