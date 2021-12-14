#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Wait until DB is up and ready
until mysql -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASSWORD}" -e 'SELECT 1'
do
  echo "DB not ready!"
  sleep 1
done

# Do DB create/migration
rails db:create
rails db:migrate
rails db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"