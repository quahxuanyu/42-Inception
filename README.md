*This project has been created as part of the 42 curriculum by xquah.*

# Inception

## Description
This project builds a small Docker-based infrastructure on a virtual machine using Docker Compose.
The mandatory architecture contains three dedicated containers:
- NGINX (TLS entrypoint on port 443 only)
- WordPress with php-fpm
- MariaDB

Two persistent storages are used:
- one volume for database data
- one volume for WordPress website files

The project source is organized as follows:
- `srcs/docker-compose.yaml`: service orchestration
- `srcs/requirements/nginx`: NGINX Dockerfile, config, TLS entrypoint script
- `srcs/requirements/wordpress`: WordPress/php-fpm Dockerfile and bootstrap script
- `srcs/requirements/mariadb`: MariaDB Dockerfile, config, init script
- `secrets/`: Docker secret files used at runtime
- `Makefile`: entrypoint for build, run, stop, and cleanup commands

Main design choices:
- Build custom images from Debian base images (no prebuilt service images)
- Keep one service per container
- Use a dedicated bridge network for internal communication
- Use `.env` for non-sensitive config and Docker secrets for passwords
- Keep startup scripts strict and fail fast when required secrets are missing

## Instructions
1. Configure local domain resolution on your VM host:
   - map `xquah.42.fr` to your VM local IP address
2. Build images:
   ```bash
   make build
   ```
3. Start services:
   ```bash
   make start
   ```
4. Stop services without removing containers:
   ```bash
   make stop
   ```
5. Show logs:
   ```bash
   make logs
   ```
6. Remove stack:
   ```bash
   make clean
   ```
7. Full cleanup (host data + images + volumes):
   ```bash
   make fclean
   ```

## Comparisons
### Virtual Machines vs Docker
- A virtual machine includes a full guest OS and consumes more resources.
- Docker containers share the host kernel and start faster.
- VMs provide stronger isolation boundaries; containers provide faster iteration for deployment workflows.

### Secrets vs Environment Variables
- Environment variables are convenient for non-sensitive runtime configuration.
- Docker secrets reduce exposure of confidential values by mounting them as files at runtime.
- This project uses both: `.env` for non-sensitive variables and Docker secrets for passwords.

### Docker Network vs Host Network
- A Docker bridge network isolates traffic and provides service-name DNS resolution between containers.
- Host network mode removes isolation and can introduce port collisions and less predictable behavior.
- This project uses a dedicated bridge network and does not use host networking.

### Docker Volumes vs Bind Mounts
- Docker named volumes are managed by Docker and provide lifecycle control at the Docker level.
- Bind mounts map explicit host paths into containers and are tied directly to host filesystem layout.
- This project uses named volumes for persistent storage definitions in Compose.

## Resources
- Docker Documentation: https://docs.docker.com/
- Docker Compose Documentation: https://docs.docker.com/compose/
- NGINX Documentation: https://nginx.org/en/docs/
- WordPress Documentation: https://wordpress.org/documentation/
- MariaDB Documentation: https://mariadb.com/kb/en/documentation/

### How AI Was Used
- AI was used to accelerate repetitive tasks: drafting documentation structure, checking command consistency, and reviewing configuration constraints.
- All generated suggestions were manually reviewed, adapted, and validated in the project context.
- AI was not used as a blind replacement for understanding; every critical setup script and configuration is explained and defensible during evaluation.
