FROM php:8.2-fpm

WORKDIR /var/www/html

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV USER_ID=1000
ENV GROUP_ID=1000

RUN apt-get update && apt-get install -y \
        curl \
        wget \
        libfreetype6-dev \
        libjpeg62-turbo-dev libwebp-dev \
        libmcrypt-dev \
        libpng-dev libzip4 \
        libzip-dev libonig-dev \
        zlib1g-dev libicu-dev g++ libmagickwand-dev --no-install-recommends  \
        libxml2-dev libxslt-dev \
        libpq-dev \
        locales locales-all

RUN docker-php-ext-configure  gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    gd zip xml \
    xsl calendar opcache \
    pdo pgsql pdo_pgsql \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=172.17.0.1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN docker-php-ext-install sockets bcmath

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/


RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

RUN chown -R www-data:www-data /var/www/html

RUN mkdir /var/www/.composer && chown -R www-data:www-data /var/www/.composer

ENV LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

USER "${USER_ID}:${GROUP_ID}"