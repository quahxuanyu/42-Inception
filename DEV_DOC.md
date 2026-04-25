# DEV_DOC

## Environment Setup From Scratch
Prerequisites:
- Linux virtual machine
- Docker Engine
- Docker Compose plugin
- GNU Make

Initial setup steps:
1. Clone repository and move to project root.
2. Review non-sensitive config in `srcs/.env`.
3. Set secret values in:
   - `secrets/db_password.txt`
   - `secrets/db_root_password.txt`
   - `secrets/db_user.txt`
   - `secrets/wp_admin.txt`
   - `secrets/wp_user.txt`
4. Ensure host folders exist:
   - `/home/<login>/data/mariadb`
   - `/home/<login>/data/wordpress`

## Build and Launch Using Makefile and Docker Compose
Main workflow:
- Build images:
  ```bash
  make build
  ```
- Start stack:
  ```bash
  make start
  ```
- Stop stack:
  ```bash
  make stop
  ```
- Remove stack:
  ```bash
  make clean
  ```

Backward-compatible aliases:
- `make up` -> `make start`
- `make down` -> `make clean`
- `make restart` -> `make re`

## Useful Commands for Containers and Volumes
- Show service state:
  ```bash
  docker compose -f srcs/docker-compose.yaml ps
  ```
- Follow logs:
  ```bash
  make logs
  ```
- Open shell in a container:
  ```bash
  docker exec -it wordpress sh
  ```
- Inspect named volumes:
  ```bash
  docker volume inspect mariadb_data wordpress_data
  ```
- Full reset (containers, volumes, images, host data):
  ```bash
  make fclean
  ```

## Data Storage and Persistence
Persistence is handled by two named volumes declared in `srcs/docker-compose.yaml`:
- `mariadb_data` for `/var/lib/mysql`
- `wordpress_data` for `/var/www/html`

Current driver options map storage to host folders:
- `/home/<login>/data/mariadb`
- `/home/<login>/data/wordpress`

Data survives container recreation until volumes and host folders are explicitly removed.
