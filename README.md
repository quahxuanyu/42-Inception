*This project has been created as part of the 42 curriculum by xquah.*

# Inception

## Description
This project builds a containerized infrastructure with Docker Compose on a virtual machine.
The mandatory stack contains three isolated services:
- NGINX as the only public entrypoint over HTTPS on port 443.
- WordPress with php-fpm.
- MariaDB as the database backend.

Data persistence is handled through two named volumes mounted on the host under `/home/xquah/data`.

## Instructions
1. Ensure your host resolves `xquah.42.fr` to your VM IP address.
2. Build and start the stack:
   ```bash
   make up
   ```
3. Stop services:
   ```bash
   make down
   ```
4. Rebuild images:
   ```bash
   make build
   ```
5. View logs:
   ```bash
   make logs
   ```
6. Full cleanup (containers + volumes):
   ```bash
   make clean
   ```

## Comparisons
### Virtual Machines vs Docker
- Virtual machines virtualize full operating systems, with higher resource overhead.
- Docker virtualizes at the process level using the host kernel, making startup faster and lighter.
- VMs are stronger isolation boundaries; containers are lighter and better for repeatable deployments.

### Secrets vs Environment Variables
- Environment variables are simple and portable but can be exposed through process inspection.
- Docker secrets are mounted at runtime with tighter access control and are safer for sensitive values.
- This project uses `.env` (mandatory), while secrets are recommended as a stronger alternative.

### Docker Network vs Host Network
- Docker bridge networks isolate services and provide DNS-based service discovery (`mariadb`, `wordpress`, `nginx`).
- Host networking bypasses isolation and can cause port conflicts and weaker separation.
- The mandatory part uses a dedicated bridge network to keep services isolated and explicit.

### Docker Volumes vs Bind Mounts
- Volumes are Docker-managed and portable across host path changes.
- Bind mounts map explicit host paths and provide direct host visibility/control.
- This project uses named volumes backed by bind mounts to satisfy the subject requirement for `/home/xquah/data/*` persistence.

## Resources
- Docker docs: https://docs.docker.com/
- Docker Compose docs: https://docs.docker.com/compose/
- NGINX docs: https://nginx.org/en/docs/
- WordPress docs: https://wordpress.org/documentation/
- MariaDB docs: https://mariadb.com/kb/en/documentation/
