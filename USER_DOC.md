# User Documentation

## What services are provided?
This stack provides:
- **NGINX** with TLS (HTTPS) as the only public entrypoint.
- **WordPress + PHP-FPM** for the website and CMS.
- **MariaDB** as the database.

## Start and stop the project
From the project root:
- Start: `make up`
- Restart: `make restart`
- Stop (without removal): `make stop`
- Remove containers: `make down`
- View logs: `make logs-follow`

## Cleanup
- Remove containers and volumes: `make clean`
- Prune dangling images: `make prune`
- Remove all images: `make rmi`
- Full cleanup (containers, images, volumes, networks, secrets): `make nuke`

## Access the website and admin panel
1) Point your domain to your local IP by editing `/etc/hosts`:
   - `127.0.0.1 <login>.42.fr` (or your local IP)
2) Open:
   - Website: `https://<login>.42.fr`
   - Admin panel: `https://<login>.42.fr/wp-admin`

## Locate and manage credentials
Credentials are stored as Docker secrets in `../.secrets` and mounted at runtime:
- `db_password.txt`
- `db_root_password.txt`
- `wp_admin_password.txt`
- `wp_user_password.txt`

Non-sensitive configuration is stored in [srcs/.env](srcs/.env) (see DEV_DOC.md for a template).

## Check services are running
- `make logs-follow` to view real-time logs for all services.
- Check the logs to confirm:
  - NGINX: TLS is active
  - WordPress: setup completed
  - MariaDB: DB is ready

## Common notes
- NGINX serves `/var/www/html` from the `webdata` volume.
- WordPress uses PHP-FPM on `WP_PORT` and connects to MariaDB on `MARIADB_PORT`.
- The admin username must **not** contain “admin/administrator” (per subject rules).
