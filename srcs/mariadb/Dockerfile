FROM debian:bookworm

RUN apt-get update -y && apt-get install mariadb-server -y 
COPY setup-mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-mariadb.sh

ENTRYPOINT ["/usr/local/bin/setup-mariadb.sh"]