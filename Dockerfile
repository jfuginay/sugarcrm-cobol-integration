FROM php:7.4-apache

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libldap2-dev \
    libcurl4-openssl-dev \
    git \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo_mysql \
        zip \
        intl \
        xml \
        ldap \
        curl \
        opcache \
        bcmath

# Enable Apache modules
RUN a2enmod rewrite headers

# Set up Apache document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/SuiteCRM
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copy SuiteCRM files
COPY ./SuiteCRM /var/www/html/SuiteCRM

# Set permissions
RUN chown -R www-data:www-data /var/www/html/SuiteCRM \
    && chmod -R 755 /var/www/html/SuiteCRM

# PHP configuration
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/memory-limit.ini
RUN echo "upload_max_filesize = 20M" > /usr/local/etc/php/conf.d/upload.ini
RUN echo "post_max_size = 20M" >> /usr/local/etc/php/conf.d/upload.ini

WORKDIR /var/www/html/SuiteCRM

EXPOSE 80