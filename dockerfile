FROM php:8.0.6-fpm-alpine

# Install necessary extensions
RUN docker-php-ext-install pdo pdo_mysql sockets

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy Composer binary from an official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy the application files
COPY . .

# Install dependencies
RUN composer install

# Generate application key
RUN php artisan key:generate

# Generate Passport keys
RUN php artisan passport:keys

# Expose port 8001
EXPOSE 8001

# Start PHP-FPM and listen on port 8001
CMD ["php-fpm", "-F", "-R", "--listen", "8001"]
