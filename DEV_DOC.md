_This project has been created as part of the 42 curriculum by nfakih._

## Environment Setup

### Prerequisites

This project requires a virtual machine and/or an EC2. This helps protect your own machine from attacks. Additionally, in case you cannot configure IP addresses to domain names (sudo access requried) you will need a virtual machine.
You will also need:
-Docker Engine
-Docker Compose
-make

### Configuration & Secrets (`.env`)

1. Generate your production configuration file from the provided boilerplate template:
   ```bash
   nano .env
   ```
2. Open `.env` and fill out your specific configuration parameters.

```
DOMAIN_NAME=

DB_NAME=
DB_USER=
DB_HOST=

WP_ADMIN_USER=
WP_ADMIN_PASSWORD=
WP_ADMIN_EMAIL=

WP_USER=
WP_USER_PASSWORD=
WP_USER_EMAIL=

WP_TITLE= 
WP_URL=
```
3. There are 2 files in secrets: db_password.txt and db_root_password.txt. Replace the passwords with the desired ones.

## 2. Architecture & Data Flow
Traffic originating from public client web browsers can only ever reach the NGINX container gateway. NGINX forms an isolated perimeter layer preventing malicious external traffic from interacting directly with upstream application endpoints.

[ Port 443 ]
Host Browser / External ----------> NGINX Container
|
| (Port 9000 FastCGI)
v
WordPress Container
|
| (Port 3306 SQL Connection)
v
MariaDB Container


* **Network Perimeter:** NGINX hosts SSL termination on port `443`.
* **Dynamic Gateway Processing:** NGINX handles static files directly and forwards dynamic PHP scripts upstream to the **WordPress** container via the **FastCGI** protocol.
* **Storage Transaction Layer:** WordPress queries execution schemas from the **MariaDB** container over an isolated internal virtual application bridge network.

---

## 3. Build and Launch

The complete infrastructure stack is managed via a Makefile automating common procedures.
This Makefile help compile required service base images, builds user-defined isolated networks, sets up volume dependencies, and provisions containers in a detached background state:

```bash
make
```

### Stop Running Containers
Gracefully stops active background workloads and removes operational software networks without impacting persistent underlying storage layers:
```bash
make stop
```

### Destruction & Clean Purge
Brings down running services and forcefully purges all attached database and file allocation volume blocks simultaneously:
```bash
make clean
```

---

## 4. Managing Containers and Volumes

Use these Docker commands to track your active system components:

```bash
# Monitor active container processes, health metrics, and mapping bindings
docker ps

# Inspect available isolated network bridge architectures
docker network ls

# List structural logical data storage volumes registered on the machine
docker volume ls
```

---

## 5. Data Storage & Persistence Verification

Data state tracking across image builds, updates, or sudden software restarts is preserved using two distinct dedicated named volumes:
1. **`test_db_volume`**: Mounts into `/var/lib/mysql` inside the container to persist relational tables.
2. **`test_wordpress_volume`**: Mounts into `/var/www/html` to store active plugins, templates, and asset uploads.

On the underlying host Linux filesystem, Docker natively stores these data directories within:
```path
/var/lib/docker/volumes/
```

### Database Tests
Execute this sequential testing script via the CLI to manually confirm proper underlying persistence across container life cycles:

#### Create test table and insert mock data
```bash
sudo docker exec mariadb mysql -u wpuser -p"wp_secure_password_456" wordpress -e "CREATE TABLE IF NOT EXISTS persistence_test (id INT, message VARCHAR(255)); INSERT INTO persistence_test VALUES (1, 'Does this survive a restart?');"
```

#### View and check current status
```bash
sudo docker exec mariadb mysql -u wpuser -p"wp_secure_password_456" wordpress -e "SELECT * FROM persistence_test;"
```

#### Simulate system crash/restart cycle
```bash
# Destroy structural container containers
docker compose down

# Reassemble background stacks from active volume states
docker compose up -d
```

#### Verify data survived the restart loop
```bash
sudo docker exec mariadb mysql -u wpuser -p"wp_secure_password_456" wordpress -e "SELECT * FROM persistence_test;"
```

#### Drop (delete) the table after confirmation
```bash
sudo docker exec mariadb mysql -u wpuser -p"wp_secure_password_456" wordpress -e "DROP TABLE persistence_test;"
```

#### Verify table is gone (returns expected query error)
```bash
sudo docker exec mariadb mysql -u wpuser -p"wp_secure_password_456" wordpress -e "SELECT * FROM persistence_test;"
```
Traffic only ever reaches NGINX. NGINX forwards PHP requests to WordPress, and WordPress then queries MariaDB.

Two Docker volumes keep data alive across restarts: one for the database, one for the
WordPress site files.


*Made with lots coffee and debugging at 42 Beirut*

