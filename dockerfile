FROM php:8.0.6-fpm-alpine

RUN docker-php-ext-install pdo pdo_mysql sockets
RUN curl -sS https://getcomposer.org/installer​ | php -- \
    --install-dir=/usr/local/bin --filename=composer

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .
RUN composer install
RUN php artisan key:generate
RUN php artisan passport:keys
# Expose the port on which the Laravel application will run
EXPOSE 8001

# Start the Laravel application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8001"]
