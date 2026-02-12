# User Documentation

## What services are provided?
This stack provides:
- **NGINX** with TLS (HTTPS) as the only public entrypoint.
- **WordPress + PHP-FPM** for the website and CMS.
- **MariaDB** as the database.

## Start and stop the project
From the project root:
- Start: `make up`
- Stop (without removal): `make stop`
- Remove containers: `make down`
- View status: `make ps`
- View logs: `make logs ARGS='-f <service>'`

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
- `make ps` to list container status.
- `make logs ARGS='-f nginx'` to confirm TLS is active.
- `make logs ARGS='-f wordpress'` to confirm WordPress setup completed.
- `make logs ARGS='-f mariadb'` to confirm DB is ready.

## Common notes
- NGINX serves `/var/www/html` from the `webdata` volume.
- WordPress uses PHP-FPM on `WP_PORT` and connects to MariaDB on `MARIADB_PORT`.
- The admin username must **not** contain “admin/administrator” (per subject rules).
