FROM php:8.2-apache

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libzip-dev \
    && docker-php-ext-install intl pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working dir
WORKDIR /var/www/html

# Copy app code
COPY . .

# Install dependencies (ignore dev)
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Apache runs by default
EXPOSE 80
CMD ["apache2-foreground"]
