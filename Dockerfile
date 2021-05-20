FROM php:7 as base

# setup okteto message
COPY bashrc /root/.bashrc

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.composer/vendor/bin/:/app/vendor/bin/

RUN apt-get update && apt-get install -y zip git libzip-dev && \
  pecl install xdebug &&  \
  pecl install zip && echo 'extension=zip.so' > /usr/local/etc/php/conf.d/zip.ini && \
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php composer-setup.php --install-dir /usr/local/bin && \
  ln -s /usr/local/bin/composer.phar /usr/local/bin/composer && \
  unlink composer-setup.php && \
  /usr/local/bin/composer global require laravel/installer

WORKDIR /app

COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY php.ini-development /usr/local/etc/php/php.ini
COPY . /app

EXPOSE 8080

CMD [ "php", "-S", "0.0.0.0:8080" ]