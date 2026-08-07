
_This project has been created as part of the 42 curriculum by nfakih._

This document explains how to run and use the Inception stack.
## What the stack provides

Inception runs a small WordPress website inside Docker. It is made of three services, each in its own container:

### nginx
The only entry point. Terminates TLS and serves the site on port 443. 
### Wordpress
Runs WordPress via php-fpm. Executes the PHP, never talks to the outside world directly. 
### mariadb
The database. Stores all posts, users and settings.                  


## Prerequisites

- A Linux virtual machine with Docker and Docker Compose installed.
- The domain `nfakih.42.fr` must resolve to the local machine. Add it to the hosts file:

```bash
echo "127.0.0.1 nfakih.42.fr" | sudo tee -a /etc/hosts
```

Without this line the site will not load, because the domain does not exist on the real
internet.

## Starting and stopping

All commands are run from the root of the repository.

```bash
make          # build the images and start all containers
make down     # stop and remove the containers (volumes are kept)
make stop     # pause the containers without removing them
make start    # resume paused containers
make re       # full rebuild from scratch
```

The first `make` takes several minutes: it builds three images from a bare Debian base,
downloads WordPress and initialises the database.

To wipe everything, **including all data**:

```bash
make fclean
```

This deletes the containers, the images and the contents of `/home/nfakih/data`. Your posts
and database are gone.

## Accessing the site

Open a browser and go to:

```
https:://52.207.157.222
```

or 
```bash
su
nano etc/hosts
#and add
52.207.157.222  nfakih.42.fr
```
Then open:
```
https://nfakih.42.fr
```


The certificate is self-signed, so the browser will warn you that the connection is not
trusted. This is expected. The traffic is fully encrypted.
Authority vouching for the identity. Click through the warning to continue.


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

The credintial livese in `srcs/.env`, which is ignored by git.
Meanwhile, the database password live in the `secrets/` directory. To read them on the machine running the
stack:

```bash
cat srcs/.env
```

To change the administrator password, either use the WordPress admin panel
(Users → Profile), or from the command line:

```bash
docker exec wordpress wp user update nfakih --user_pass='new_password' --allow-root
```

Changing a value in `.env` after the first launch has no effect, because the credentials are
already written into the database and into `wp-config.php`. Only a `make fclean` followed by
`make` will re-read them.

## Checking that the services are running

List the containers and their state:

```bash
make status
```

All three should show `Up`. If one shows `Restarting`, it is crash-looping — check its logs.

Follow the logs of every service:

```bash
make logs
```

Look at a single service:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

Confirm the database is reachable and holds the WordPress tables:

```bash
docker exec -it mariadb mysql -u root -p -e "SHOW DATABASES;"
```

Confirm the TLS version being negotiated:

```bash
openssl s_client -connect nfakih.42.fr:443 -tls1_3 </dev/null 2>/dev/null | grep Protocol
```

*Made with lots coffee and debugging at 42 Beirut*

