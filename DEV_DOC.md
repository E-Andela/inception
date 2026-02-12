# Developer Documentation

## Prerequisites
- Docker and Docker Compose (plugin) installed.
- Make installed.
- Domain configured as `<login>.42.fr` mapped to your local IP.

## Project layout
- [srcs/docker-compose.yml](srcs/docker-compose.yml)
- [srcs/requirements/nginx](srcs/requirements/nginx)
- [srcs/requirements/wordpress](srcs/requirements/wordpress)
- [srcs/requirements/mariadb](srcs/requirements/mariadb)
- Secrets in `.secrets`

## Configuration files
### Environment variables
Create [srcs/.env](srcs/.env) with at least:
- `DOMAIN_NAME=<login>.42.fr`
- `DB_NAME=wordpress`
- `DB_USER=<user>`
- `DB_HOST=mariadb`
- `WP_ADMIN_USER=<admin name>`
- `WP_ADMIN_EMAIL=<email>`
- `WP_USER=<author name>`
- `WP_USER_EMAIL=<email>`

### Secrets
Create these files in `.secrets` in the root of the folder:
- `db_password.txt`
- `db_root_password.txt`
- `wp_admin_password.txt`
- `wp_user_password.txt`

## Build and launch
- Build images: `make build`
- Launch stack: `make up`
- Rebuild from scratch: `make rebuild`

## Convenience
- Copy secrets and `.env` into place: `make env` (expects files in `/home/eandela/Documents`)

## Manage containers & volumes
- Stop/start: `make stop` / `make start`
- Restart: `make restart`
- Logs: `make logs-follow`
- Remove containers: `make down`
- Remove containers and volumes: `make clean`
- Prune dangling images: `make prune`
- Remove all images: `make rmi`
- Full rebuild: `make rebuild`
- Full cleanup (containers, images, volumes, networks, secrets): `make nuke`

## Data persistence
- WordPress files: volume `webdata` mounted to `/var/www/html`.
- MariaDB data: volume `dbdata` mounted to `/var/lib/mysql`.

Per subject requirements, these named volumes must live under `/home/<login>/data` on the host. If your Docker daemon uses a custom data root, set it accordingly and verify with:
- `docker volume inspect webdata`
- `docker volume inspect dbdata`

## Service details
- **NGINX**: generates a self-signed TLS cert on startup and uses envsubst on `nginx.conf.template`.
- **WordPress**: uses WP-CLI during entrypoint to install core and create users.
- **MariaDB**: initializes DB/users on first run and exposes `MARIADB_PORT` to the network.

## Notes from implementation
- PHP-FPM listens on `0.0.0.0:9000` (see `www.conf` update in the WordPress Dockerfile).
- NGINX forwards `.php` requests to `wordpress:9000` on the `webnet` network.
- TLS is configured for `TLSv1.2` and `TLSv1.3` only.
