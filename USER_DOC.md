# User Documentation

This document explains how to run and use the Inception stack. It is aimed at an end user
or administrator, not at someone modifying the code. For that, see `DEV_DOC.md`.

## What the stack provides

Inception runs a small WordPress website inside Docker. It is made of three services, each
in its own container:

| Service    | Role                                                                 |
| ---------- | -------------------------------------------------------------------- |
| `nginx`    | The only entry point. Terminates TLS and serves the site on port 443. |
| `wordpress`| Runs WordPress via php-fpm. Executes the PHP, never talks to the outside world directly. |
| `mariadb`  | The database. Stores all posts, users and settings.                  |

Traffic only ever reaches NGINX. NGINX forwards PHP requests to WordPress, and WordPress
queries MariaDB. Neither WordPress nor MariaDB is reachable from outside the Docker network.

Two Docker volumes keep data alive across restarts: one for the database, one for the
WordPress site files.

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
and database are gone. Use it deliberately.

## Accessing the site

Open a browser and go to:

```
https://nfakih.42.fr
```

The certificate is self-signed, so the browser will warn you that the connection is not
trusted. This is expected. The traffic is fully encrypted; there is simply no Certificate
Authority vouching for the identity. Click through the warning to continue.

Note that only HTTPS on port 443 works. There is no HTTP on port 80 — this is deliberate,
as the subject requires NGINX to be the sole entry point over TLS.

### Administration panel

```
https://nfakih.42.fr/wp-admin
```

Log in with the administrator credentials described below. From here you can write posts,
manage users, install plugins and change site settings.

## Credentials

There are two WordPress accounts, created automatically on first launch:

| Account       | Role          | Can do                                        |
| ------------- | ------------- | --------------------------------------------- |
| `nfakih`      | Administrator | Everything, including installing plugins.     |
| `john_doe`    | Author        | Write and publish their own posts only.       |

The passwords are **not** stored in this repository. They live in `srcs/.env`, which is
ignored by git, and in the `secrets/` directory. To read them on the machine running the
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

## Troubleshooting

**The browser cannot reach the site at all.** The hosts file entry is probably missing. Check
with `ping nfakih.42.fr` — it should answer from `127.0.0.1`.

**"502 Bad Gateway".** NGINX is up but cannot reach php-fpm. The WordPress container is
likely still starting, or has crashed. Check `docker logs wordpress`.

**"Error establishing a database connection".** MariaDB is not ready or the credentials do
not match. Check `docker logs mariadb`.

**The site is stuck on a placeholder page.** A leftover file in the WordPress volume is
shadowing the real site. `make fclean && make` clears it.