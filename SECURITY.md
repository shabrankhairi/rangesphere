# Security & Responsible Use

RangeSphere is a **security training range**. It intentionally runs vulnerable
applications and offensive tooling. Treat the entire deployment as a hostile,
disposable environment.

## Run it safely

- **Isolated host only.** Deploy on a dedicated training machine or VM, never on a
  server shared with production services.
- **Network segregation.** Keep the host off the public internet. Do not expose the
  portal or any launched instance to the internet. For LAN access use an isolated
  training network (and only then set `TARGET_BIND_HOST=0.0.0.0`).
- **Docker socket.** The backend mounts `/var/run/docker.sock` to launch instances,
  which grants it full control of the host Docker daemon. Only run RangeSphere on a
  host where that trust is acceptable.
- **Instances are disposable.** Targets and attacker boxes are vulnerable by design and
  are auto-removed on a TTL. Don't store anything of value in them.

## Harden your deployment

- Change every secret in `.env` before first run: `PGPASSWORD`, `JWT_SECRET`.
- Create your admin from inside the system (`docker compose run --rm backend node
  src/admincli.js set <user> <pass>`) and keep that password private — it is never
  stored in config.
- Set `ALLOW_OPEN_REGISTRATION=false` after your team has enrolled.
- Put the portal behind your own VPN/SSO if teammates connect remotely.

## Authorized use only

Use the offensive tooling only against the targets RangeSphere launches, or systems you
own or are explicitly authorized in writing to test. Attacking third-party systems is
illegal and prohibited by the license.

## Reporting

Found a problem with RangeSphere itself? Contact the author:
https://www.linkedin.com/in/shabrankhairi/
