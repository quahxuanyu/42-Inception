# USER_DOC

## Services Provided
The stack provides three services:
- `nginx`: HTTPS entrypoint on port 443
- `wordpress`: application service running php-fpm
- `mariadb`: database backend for WordPress

## Start and Stop the Project
From repository root:
- Build images:
  ```bash
  make build
  ```
- Start the stack:
  ```bash
  make start
  ```
- Stop running containers:
  ```bash
  make stop
  ```
- Remove containers:
  ```bash
  make clean
  ```

Alias commands also exist:
- `make up` (same as `make start`)
- `make down` (same as `make clean`)

## Access Website and Admin Panel
1. Configure host mapping on your VM host:
   - `<VM_IP> xquah.42.fr`
2. Access the website:
   - `https://xquah.42.fr`
3. Access WordPress admin panel:
   - `https://xquah.42.fr/wp-admin`

## Locate and Manage Credentials
Non-sensitive variables are in:
- `srcs/.env`

Secret files are in:
- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/db_user.txt`
- `secrets/wp_admin.txt`
- `secrets/wp_user.txt`

Update secret files before first initialization when changing passwords.
If WordPress or MariaDB was already initialized, run a full reset to reinitialize with new credentials:
```bash
make fclean
make start
```

## Check That Services Are Running Correctly
- Container status:
  ```bash
  docker compose -f srcs/docker-compose.yaml ps
  ```
- Service logs:
  ```bash
  make logs
  ```
- HTTPS check:
  ```bash
  curl -kI https://xquah.42.fr
  ```
