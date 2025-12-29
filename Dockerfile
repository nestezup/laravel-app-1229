FROM php:8.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libicu-dev \
    libzip-dev \
    default-mysql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl zip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js (Latest stable)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# PHP-FPM이 모든 인터페이스에서 listen 하게 강제 설정
RUN sed -i 's|^listen =.*|listen = 0.0.0.0:9000|' /usr/local/etc/php-fpm.d/www.conf

# Set working directory
WORKDIR /var/www

# Copy files
COPY . .

# Install dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev
RUN npm install && npm run build
RUN php artisan filament:optimize

# Set permissions
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose port
EXPOSE 9000

# Entrypoint script to handle startup commands
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
