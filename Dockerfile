FROM php:7
WORKDIR /app
COPY index.php /app
CMD [ "php", "-S", "0.0.0.0:8080" ]