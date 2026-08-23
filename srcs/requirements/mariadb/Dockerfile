FROM debian:bookworm

RUN sed -i '0,/deb.debian.org\/debian$/s|deb.debian.org/debian$|ftp.debian.org/debian|' /etc/apt/sources.list.d/debian.sources

RUN apt-get update -y && apt-get install mariadb-server -y 
COPY tools/setup-mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-mariadb.sh

ENTRYPOINT ["/usr/local/bin/setup-mariadb.sh"]