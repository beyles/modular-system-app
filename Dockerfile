# Use official PHP 8.2 with Apache
FROM php:8.2-apache

# Install required PHP extensions + system tools
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    && docker-php-ext-install pdo pdo_mysql

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# ✅ Create a Symfony project during build
RUN composer create-project symfony/skeleton .

# Configure Apache to serve Symfony public/ folder
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

EXPOSE 80

CMD ["apache2-foreground"]
