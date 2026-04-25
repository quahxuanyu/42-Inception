# DEV_DOC

## Environment Setup
- OS target: Linux virtual machine.
- Required tools: Docker Engine + Docker Compose plugin + GNU Make.
- Project structure:
  - `srcs/docker-compose.yaml`: service orchestration.
  - `srcs/requirements/*`: Dockerfiles and service configs.
  - `srcs/.env`: runtime environment variables.

## Build and Run with Makefile
From repository root:
- Build images:
  ```bash
  make build
  ```
- Start stack:
  ```bash
  make up
  ```
- Stop stack:
  ```bash
  make down
  ```
- Tail logs:
  ```bash
  make logs
  ```
- Full reset:
  ```bash
  make clean
  ```

## Data Persistence
Two named volumes persist data and are mapped to host paths:
- MariaDB data: `/home/xquah/data/mariadb`
- WordPress files: `/home/xquah/data/wordpress`

These paths are configured in `srcs/docker-compose.yaml` under `volumes.driver_opts.device`.
They must exist on the VM host and survive container recreation.
