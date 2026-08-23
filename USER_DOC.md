
_This project has been created as part of the 42 curriculum by nfakih._

This document explains how to run and use the Inception stack.

## Overview

Inception runs a small WordPress website inside Docker. It is made of three services, each in its own container:

### nginx
The only entry point, it terminates TLS and serves the site on port 443. 
### Wordpress
Runs WordPress via php-fpm, it executes the PHP and never talks to the outside world directly. 
### mariadb
The database, which stores all posts, users and settings.                  


## Prerequisites

- A Linux virtual machine with Docker and Docker Compose installed.
- A DNS configuration, mentioned below

## Starting and stopping

All commands are run from the root of the repository.

```bash
make          # build the images and start all containers, this will take a few minutes
make down     # stop and remove the containers (volumes are kept)
make stop     # pause the containers without removing them
make start    # resume paused containers
make re       # full rebuild from scratch

make fclean   # wipes everything, including database
```

## Accessing the site

Open a browser and go to:

```
https:://52.207.157.222
```

or 

```bash
su
nano etc/hosts
# and add
52.207.157.222  nfakih.42.fr
```

Then open:
```
https://nfakih.42.fr
```

The certificate is self-signed, therefore there will be a warning from the browsers. However the traffic is fully encrypted.
Click to continue.


### Administration panel

```
https://nfakih.42.fr/wp-admin
```
Log in with the administrator credentials described below. From here you can write posts,
manage users, install plugins and change site settings.

## Credentials

There are two WordPress accounts, created automatically on first launch:

| Account       | Role          |
| ------------- | ------------- |
| `nfakih`      | Administrator |
| `john_doe`    | Author        |

The credintials live in srcs/.env, which is ignored by git.
Meanwhile, the database passwords live in the secrets/ directory.

```bash
cat srcs/.env
```

To change the administrator password, either use the WordPress admin panel
or from the command line:

```bash
docker exec wordpress wp user update nfakih --user_pass='new_password' --allow-root
```

Changing a value in `.env` after the first launch has no effect, to change them fclean first.

## Checking that the services are running

List the containers and their state:

```bash
make status
```

All three should show "Up".

To check the logs of every service:

```bash
make logs
```
or

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

To confirm the database is reachable and holds the WordPress tables:

```bash
docker exec -it mariadb mysql -u root -p -e "SHOW DATABASES;"
```

To confirm the TLS version being negotiated:

```bash
openssl s_client -connect nfakih.42.fr:443 -tls1_3 </dev/null 2>/dev/null | grep Protocol
```

*Made with lots coffee and debugging at 42 Beirut*

