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
- `NGINX_PORT=443`
- `WP_PORT=9000`
- `MARIADB_PORT=3306`
- `DB_NAME=wordpress`
- `DB_USER=<user>`
- `DB_HOST=mariadb`
- `WP_ADMIN_USER=<non-admin name>`
- `WP_ADMIN_EMAIL=<email>`
- `WP_USER=<author name>`
- `WP_USER_EMAIL=<email>`

### Secrets
Create these files in `../.secrets` (ignored by git):
- `db_password.txt`
- `db_root_password.txt`
- `wp_admin_password.txt`
- `wp_user_password.txt`

## Build and launch
- Build images: `make build`
- Launch stack: `make up`
- Rebuild from scratch: `make rebuild`

## Manage containers & volumes
- Stop/start: `make stop` / `make start`
- Logs: `make logs ARGS='-f <service>'`
- Shell into service: `make shell SERVICE=<service>`
- Execute command: `make exec SERVICE=<service> CMD='command'`
- Remove containers and volumes: `make clean`
- Show compose status: `make status`

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
- PHP-FPM listens on `0.0.0.0:${WP_PORT}` (see `www.conf` update in the WordPress Dockerfile).
- NGINX forwards `.php` requests to `wordpress:${WP_PORT}` on the `webnet` network.
- TLS is configured for `TLSv1.2` and `TLSv1.3` only.
