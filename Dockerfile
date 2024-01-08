# Use an official PHP image as a base image
FROM php:7.4-apache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install necessary extensions and tools
RUN docker-php-ext-install mysqli && \
    apt-get update && \
    apt-get install -y libzip-dev libicu-dev && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl zip

# copy apache server configration 
COPY ./phpproject/apache/default.conf /etc/apache2/sites-available/000-default.conf

# Copy the current directory contents into the container at /var/www/html
COPY ./phpproject /var/www/html

RUN chown -R www-data:www-data /var/www

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install Composer dependencies
RUN composer install --no-ansi --no-interaction --no-progress --no-scripts --optimize-autoloader --ignore-platform-reqs --prefer-dist

# Expose port 80 to the host
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
