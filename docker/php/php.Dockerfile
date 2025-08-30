FROM php:8.4-fpm-alpine

RUN mkdir -p /var/www/html
#RUN chown  -p www-data:www-data /var/www/html
WORKDIR /var/www/html

# persistent dependencies
RUN set -eux; \
  apk add --no-cache \
  # in theory, docker-entrypoint.sh is POSIX-compliant, but priority is a working, consistent image
  bash \
  # Ghostscript is required for rendering PDF previews
  ghostscript \
  # Alpine package for "imagemagick" contains ~120 .so files, see: https://github.com/docker-library/wordpress/pull/497
  imagemagick \
  ;

RUN \ 
  docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
  && docker-php-ext-install pdo pdo_mysql

# install the PHP extensions we need (https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions)
RUN set -ex; \
  \
  apk add --no-cache --virtual .build-deps \
  $PHPIZE_DEPS \
  freetype-dev \
  icu-dev \
  imagemagick-dev libheif-dev \
  libavif-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  libwebp-dev \
  libzip-dev \
  ; \
  \
  docker-php-ext-configure gd \
  --with-avif \
  --with-freetype \
  --with-jpeg \
  --with-webp \
  ; \
  docker-php-ext-install -j "$(nproc)" \
  bcmath \
  exif \
  gd \
  intl \
  mysqli \
  zip \
  ; \
  # WARNING: imagick is likely not supported on Alpine: https://github.com/Imagick/imagick/issues/328
  # https://pecl.php.net/package/imagick
  pecl install imagick-3.8.0; \
  docker-php-ext-enable imagick; \
  rm -r /tmp/pear;

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN set -eux; \
  docker-php-ext-enable opcache; \
  { \
  echo 'opcache.memory_consumption=128'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=4000'; \
  echo 'opcache.revalidate_freq=2'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# https://wordpress.org/support/article/editing-wp-config-php/#configure-error-logging
RUN { \
  # https://www.php.net/manual/en/errorfunc.constants.php
  # https://github.com/docker-library/wordpress/issues/420#issuecomment-517839670
  echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
  echo 'display_errors = Off'; \
  echo 'display_startup_errors = Off'; \
  echo 'log_errors = On'; \
  echo 'error_log = /dev/stderr'; \
  echo 'log_errors_max_len = 1024'; \
  echo 'ignore_repeated_errors = On'; \
  echo 'ignore_repeated_source = Off'; \
  echo 'html_errors = Off'; \
  } > /usr/local/etc/php/conf.d/error-logging.ini

EXPOSE 9000
CMD ["php-fpm"]
