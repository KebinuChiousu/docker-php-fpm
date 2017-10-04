FROM php:7.1-fpm

MAINTAINER Kevin Meredith <kevin@meredithkm.info>

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y --no-install-recommends \
       wget \
       git \
       unzip \
       zip \
       zlib1g-dev \ 
       less \ 
       vim-tiny \
       psmisc \
       python3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN ln -s /usr/bin/vim.tiny /usr/bin/vim

RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) pcntl
RUN docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-install -j$(nproc) opcache

RUN pecl install xdebug \
    && pecl install apcu \
    && docker-php-ext-enable xdebug apcu

RUN mkdir -p /usr/local/bin

WORKDIR /usr/local/bin

COPY bin/install_composer /usr/local/bin/install_composer
RUN chmod a+x /usr/local/bin/install_composer
RUN /usr/local/bin/install_composer \
    &&  mv /usr/local/bin/composer.phar composer

RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

COPY bin/setuser /sbin/setuser
RUN chmod a+x /sbin/setuser

WORKDIR /usr/local/openresty/nginx

