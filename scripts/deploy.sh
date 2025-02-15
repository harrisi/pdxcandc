#!/bin/bash

set -eo pipefail

REMOTE_USER="${REMOTE_USER:-deploy}"
REMOTE_HOST="${REMOTE_HOST:-pdxcode.coffee}"
SITE_ROOT="${SITE_ROOT:-/var/www/pdxcandc}"
NGINX_CONF="${NGINX_CONF:-/etc/nginx/sites-available/pdxcandc.conf}"
NGINX_ENABLED="${NGINX_ENABLED:-/etc/nginx/sites-enabled/pdxcandc.conf}"

if [ -f .env/prod ]; then
  source .env/prod
fi

echo "syncing files"
RSYNC_OUTPUT=$(rsync \
  --archive \
  --verbose \
  --compress \
  --delete \
  --include-from='.rsyncinclude' \
  ./ "$REMOTE_USER@$REMOTE_HOST:$SITE_ROOT/")

ssh "$REMOTE_USER@$REMOTE_HOST" "curl -X POST localhost:${PORT:-4321}"

echo "done"