FROM debian:bookworm
#each from creates a single image

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-xml \
    php-mbstring \
    php-zip \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*
    #rm the cache for smaller image
    #running all together means less layers
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
    #managing wordpress from the terminal
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY setup-wordpress.sh /usr/local/bin/
#copy from pc to image
RUN chmod +x /usr/local/bin/setup-wordpress.sh

EXPOSE 9000

WORKDIR /var/www/html
#execution starts from this directory

ENTRYPOINT ["setup-wordpress.sh"]
#at container start