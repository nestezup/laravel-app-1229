#!/bin/bash
set -e

# Wait for MySQL to be ready (simple wait)
echo "Waiting for MySQL..."
sleep 5

# Run migrations and cache
echo "Running migrations..."
php artisan migrate --force

echo "Caching configuration..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Execute the main command (php-fpm)
exec "$@"
