<div align="center">

# ◎ RangeSphere

**Self-hosted web-app security training range — red & blue, on your own infra.**

Spin up isolated, intentionally-vulnerable targets and a live in-browser attacker box.
Hack, capture the flag, and auto-verify. 27 hand-built challenges across two tracks.

*Freeware · runs on Docker · not open source*

</div>

---

## What it is

RangeSphere is a TryHackMe/Hack-The-Box-style range you host yourself. Each challenge
launches an isolated target plus a Kali-based **attacker box** with an in-browser
terminal (ttyd) and web-pentest tools. Blue-team challenges ship an **analyst box**
with evidence to triage.

- **40 challenges** — 20 Red (offensive) + 20 Blue (DFIR / detection), incl. an *insane* fileless-APT memory-forensics lab
- **Per-challenge writeup PDF** (admin only) — downloadable answer key straight from the challenge page
- **Live attacker box** — nmap, sqlmap, ffuf, nikto, gobuster, wordlists
- **Per-instance isolation** — each user gets a target + box on a private Docker network, auto-torn-down on a TTL
- **Auto-checker + flags** — unique `FLAG{…}` per instance, plus a per-challenge objective checker
- **Scoreboard & teams**, **admin UI**, instructor writeups, and per-challenge learning references

> This repository ships **pre-built images only** — no source code. See [LICENSE](LICENSE).

---

## Requirements

- Linux host or Docker Desktop (Windows/WSL2 or macOS)
- Docker Engine + Docker Compose plugin
- The backend controls the host Docker daemon (mounts `/var/run/docker.sock`) to launch instances

> ⚠️ **Run only on an isolated training host.** RangeSphere deploys vulnerable apps and
> offensive tooling by design. Keep the host segregated from production and the public
> internet. See [SECURITY.md](SECURITY.md).

---

## Quick start

```bash
# 1. get these deployment files
git clone https://github.com/shabrankhairi/rangesphere.git
cd rangesphere

# 2. configure
cp .env.example .env        # edit secrets (DB password, JWT secret, admin password)

# 3. launch (pulls images, migrates, seeds, runs)
./start.sh
```

Then open **http://localhost:8080**.

### Logging in

- **Demo account (default):** `demo` / `demo123` — a normal member. Anyone can log in and play.
- **Admin:** not configured in any file. The operator creates/resets the admin **from inside the
  running system**, so the password is stored hashed in the DB and never sits in config:

  ```bash
  docker compose run --rm backend node src/admincli.js set <username> <password>
  ```

  Until an admin is created there is **no admin** (members use the demo account; writeups stay
  hidden). On the public demo, ask the maintainer for admin access. Once you have an admin, you
  can create/manage other users (member or admin) from the **Admin → Users** panel, or with
  `admincli.js` (`list`, `passwd`, `demote`, `delete`).

### Manual steps (or Windows PowerShell)

```bash
docker compose pull
docker compose up -d db
docker compose run --rm backend node src/migrate.js
docker compose run --rm backend node src/seed/seed.js
docker compose up -d
```

The first time a challenge is started, its target image is pulled — that launch takes a little longer.

---

## For your team

- Members self-register on the login page (role `member`). Set `ALLOW_OPEN_REGISTRATION=false`
  in `.env` once everyone is enrolled.
- For access from other machines on an **isolated** LAN, set `TARGET_BIND_HOST=0.0.0.0`
  and reach the portal/instances via the host's IP.
- **Create your admin** with `admincli.js set` (above) and keep that password private —
  there is no admin until you do.

---

## Tracks

| 🔴 Red Team (18) | 🔵 Blue Team (17) |
|---|---|
| SQLi, command injection, NoSQLi, SSTI→RCE, XXE | Access-log triage, Log4Shell hunt, SQLi-dump triage |
| IDOR, mass assignment, LFI, unrestricted upload | Webshell hunt, persistence hunt, malware dropper |
| SSRF, SSRF→cloud metadata, GraphQL, race condition | DNS tunneling, proxy exfil, SSH & Windows brute force |
| open redirect, CORS misconfig, insecure deserialization | JWT forensics, phishing triage, PowerShell decode, credential stuffing, C2 beacon detect |
| | **memory forensics (injected process)**, **Linux rootkit hunt** |

---

## Updating

```bash
docker compose pull
docker compose run --rm backend node src/migrate.js
docker compose run --rm backend node src/seed/seed.js
docker compose up -d
```

---

## License

RangeSphere is **freeware**, not open source. You may download and run it for authorized
security training; you may not reverse-engineer, redistribute, modify, or resell it.
See [LICENSE](LICENSE). Built by [Shabran Al Khairi](https://www.linkedin.com/in/shabrankhairi/).
