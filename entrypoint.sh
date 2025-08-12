#!/bin/sh
set -e

rm -f tmp/pids/server.pid

# Detect RAILS_ENV (default to production if not set)
export RAILS_ENV=${RAILS_ENV:-production}

echo "💡 Running in $RAILS_ENV environment"


# Run migrations
echo "🚀 Running database migrations..."
bundle exec rails db:migrate

# Seed database (optional in prod — comment out if not needed)
if [ "${RUN_SEED:-true}" = "true" ]; then
  echo "🌱 Seeding database..."
  bundle exec rails db:seed
fi

# Start the Rails server
echo "🔥 Starting Rails server..."
exec bundle exec rails server -b 0.0.0.0 -p "${PORT:-3000}"
