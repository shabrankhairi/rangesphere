#!/usr/bin/env bash
# RangeSphere — upgrade in place, KEEPING all data (users, scores, solves).
# For a clean wipe instead, see README "Upgrading → B" (docker compose down -v).
set -euo pipefail
cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "[upgrade] no .env found — copying from .env.example (edit your secrets!)"
  cp .env.example .env
fi
set -a; . ./.env; set +a

echo "[upgrade] pulling latest images…"
docker compose pull

echo "[upgrade] starting database…"
docker compose up -d db
until docker compose exec -T db pg_isready -U "${PGUSER:-rangesphere}" >/dev/null 2>&1; do sleep 1; done

echo "[upgrade] applying new migrations (idempotent)…"
docker compose run --rm backend node src/migrate.js

echo "[upgrade] seeding new challenges + refreshing writeups (upsert)…"
docker compose run --rm backend node src/seed/seed.js

echo "[upgrade] restarting on the new images…"
docker compose up -d

echo
echo "[upgrade] done → http://localhost:${PORTAL_PORT:-8080}"
echo "          Your users, scores and solves are preserved."
echo "          No admin yet? docker compose run --rm backend node src/admincli.js set <user> <pass>"
