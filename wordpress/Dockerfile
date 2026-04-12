FROM debian::bookworm
#each from creates a single image

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-zip \
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
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/setup-wordpress.sh /usr/local/bin/
#copy from pc to image
RUN chmod +x /usr/local/bin/setup-wordpress.sh

EXPOSE 9000

WORKDIR /var/www/html
#execution starts from this directory

ENTRYPOINT ["tools/setup-wordpress.sh"]
#at container start