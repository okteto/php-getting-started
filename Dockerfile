FROM php:8.5.12-cli-trixie AS dev

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    pecl install xdebug-3.5.3 && \
    docker-php-ext-enable xdebug && \
    cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY --from=composer:2.11.2 /usr/bin/composer /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY xdebug.ini $PHP_INI_DIR/conf.d/

WORKDIR /usr/src/app
COPY composer.json composer.lock ./
# The cache mount keeps Composer's download cache in the Okteto Build Service,
# which reuses it between builds. The tests of the Okteto Manifest use the
# same cache
RUN --mount=type=cache,target=/root/.composer/cache \
    composer install
COPY . .

FROM php:8.5.12-cli-alpine3.24 AS prod

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
WORKDIR /usr/src/app
COPY *.php ./
COPY static static
CMD ["php", "-S", "0.0.0.0:8080"]
