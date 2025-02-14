#!/bin/bash

set -eo pipefail

REMOTE_USER="${REMOTE_USER:-deploy}"
REMOTE_HOST="${REMOTE_HOST:-10.10.10.10}"
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
  --itemize-changes \
  --include-from='.rsyncinclude' \
  ./ "$REMOTE_USER@$REMOTE_HOST:$SITE_ROOT/")

if echo "$RSYNC_OUTPUT" | grep -q 'conf'; then
  echo "updating nginx config"
  ssh "$REMOTE_USER@$REMOTE_HOST" <<EOF
    sudo cp $SITE_ROOT/config/pdxcandc.conf $NGINX_CONF

    sudo nginx -t && sudo systemctl reload nginx
EOF
fi

echo "done"