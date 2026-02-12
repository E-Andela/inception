*This project has been created as part of the 42 curriculum by eandela.*

# Inception

## Description
This project builds a small infrastructure using Docker Compose with three custom-built services: NGINX (TLS-only entrypoint), WordPress with PHP-FPM, and MariaDB. The stack runs on a dedicated Docker network and persists data in two named volumes (database and WordPress files). All images are built from Debian oldstable, and no prebuilt service images are pulled.

**Goal:** deliver a secure, reproducible, self-hosted WordPress stack with proper separation of concerns and safe credential handling via environment variables and Docker secrets.

## Project Overview
**Services**
- **NGINX**: TLSv1.2/1.3 termination and reverse proxy to PHP-FPM.
- **WordPress + PHP-FPM**: application runtime and content management.
- **MariaDB**: database backend.

**Docker resources**
- **Network**: `webnet` for inter-container communication.
- **Volumes**: `webdata` for WordPress files, `dbdata` for MariaDB data.

## Design Choices & Sources
- **Debian oldstable** is used as the base image to comply with the "penultimate stable" requirement. I would have preferred using the explicit version name `bookworm`, but it's unclear whether that satisfies the subject's wording, so `oldstable` is used to be safe.
- **TLS-only NGINX** is the single entrypoint on port 443; a self-signed certificate is generated during container startup.
- **WP-CLI** installs and configures WordPress at runtime to avoid volume overwrite issues.
- **Secrets** are stored in .secrets and mounted into containers to prevent credentials from living in images or source.

## Comparisons (Required)
### Virtual Machines vs Docker
- **VMs** virtualize hardware and run a full OS per instance; heavier and slower to boot.
- **Docker** virtualizes the application layer, shares the host kernel, starts faster, and uses fewer resources.

### Secrets vs Environment Variables
- **Environment variables** are convenient for non-sensitive settings (domain, ports) but are visible via `docker inspect`.
- **Docker secrets** are mounted as files with stricter permissions and are preferred for passwords/credentials.

### Docker Network vs Host Network
- **Docker network** isolates services and allows container discovery by name; safer and portable.
- **Host network** removes isolation and risks port conflicts; forbidden by the subject.

### Docker Volumes vs Bind Mounts
- **Named volumes** are managed by Docker and are portable; required for this project.
- **Bind mounts** map host paths directly; more error‑prone and forbidden for persistent data here.

## Instructions
### 1) Configure environment
Create your `.env` in [srcs/.env](srcs/.env) and place secrets in [/.secrets](/.secrets) (see DEV_DOC.md for full details).

### 2) Build and run
- Build: `make build`
- Start: `make up`
- Restart: `make restart`
- Logs: `make logs-follow`
- Stop: `make stop`
- Remove: `make down`
- Clean (remove volumes): `make clean`
- Prune dangling images: `make prune`
- Remove all images: `make rmi`
- Full cleanup (containers, images, volumes, networks, secrets): `make nuke`

### 3) Access
- Website: `https://<login>.42.fr` (update `/etc/hosts` to map your domain to your local IP)
- WordPress admin: `https://<login>.42.fr/wp-admin`

## Resources
- Docker Curriculum: https://docker-curriculum.com/
- Docker Docs: https://docs.docker.com/
- Docker Compose file reference: https://docs.docker.com/compose/compose-file/
- Docker Volumes: https://docs.docker.com/storage/volumes/
- Docker Networks: https://docs.docker.com/network/
- Docker Secrets: https://docs.docker.com/compose/how-tos/use-secrets/
- NGINX TLS termination: https://nginx.org/en/docs/http/ngx_http_ssl_module.html
- WordPress Docker image docs (CLI usage concepts): https://github.com/docker-library/docs/tree/master/wordpress
- WordPress CLI commands: https://developer.wordpress.org/cli/commands/

**AI usage**
- Used for drafting documentation structure and wording.
- Used to summarize Docker concepts (networks, volumes, secrets) and incorporate project notes.
