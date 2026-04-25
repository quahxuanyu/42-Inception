# USER_DOC

## Start and Stop
- Start all services:
  ```bash
  make up
  ```
- Stop all services:
  ```bash
  make down
  ```
- Rebuild images:
  ```bash
  make build
  ```
- Stream logs:
  ```bash
  make logs
  ```
- Remove containers, volumes, and orphans:
  ```bash
  make clean
  ```

## Access the Site
1. Add host mapping on your VM host:
   - `<VM_IP> xquah.42.fr`
2. Open:
   - `https://xquah.42.fr`

## Credentials Management
All runtime credentials are configured in `srcs/.env`:
- MariaDB: `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`
- WordPress admin: `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_ADMIN_EMAIL`
- WordPress user: `WP_USER`, `WP_USER_PASSWORD`, `WP_USER_EMAIL`

Update values in `.env` before running `make up`.
If WordPress was already initialized, run `make clean` to recreate data with new credentials.
