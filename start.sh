#!/usr/bin/env bash
# RangeSphere — public one-shot launcher (pulls images, migrates, seeds, runs).
set -euo pipefail
cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "[start] creating .env from .env.example — edit the secrets!"
  cp .env.example .env
fi
set -a; . ./.env; set +a

echo "[start] pulling images…"
docker compose pull

echo "[start] starting database…"
docker compose up -d db
until docker compose exec -T db pg_isready -U "${PGUSER:-rangesphere}" >/dev/null 2>&1; do sleep 1; done

echo "[start] applying schema + seeding challenges…"
docker compose run --rm backend node src/migrate.js
docker compose run --rm backend node src/seed/seed.js

echo "[start] launching portal…"
docker compose up -d

echo
echo "[start] RangeSphere is up → http://localhost:${PORTAL_PORT:-8080}"
echo "        Admin: ${ADMIN_USER:-admin} (password from .env)"
echo "        First 'Start instance' per challenge pulls its target image — be patient."
