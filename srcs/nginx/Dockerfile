FROM debian:bookworm

RUN apt update -y && apt install -y nginx && apt install openssl -y \
	&& rm -rf /var/lib/apt/lists/* && mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=LB/ST=Mont-Liban/L=Baabda/O=42/OU=42/CN=nfakih.42.fr"

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html/index.html
#im writing on the host here, i need to copy it to docker
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

# docker processes need to be running in the background, if i put daemon on
# it would have stopped the container
# -g means set global directive, basically we can configure from the terminal
# [] make it run as PID 1