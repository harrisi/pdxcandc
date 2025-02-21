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
  --checksum \
  --verbose \
  --compress \
  --delete \
  --itemize-changes \
  --include-from='.rsyncinclude' \
  ./ "$REMOTE_USER@$REMOTE_HOST:$SITE_ROOT/")

echo "rsync output:"
echo "$RSYNC_OUTPUT"
echo "---"

# "curl -X POST localhost:${PORT:-4321}"
# only reload if there are changes
if [ -n "$(echo "$RSYNC_OUTPUT" | egrep '^<')" ]; then
  ssh "$REMOTE_USER@$REMOTE_HOST" "$(cat scripts/trigger.sh)"
  echo "reloaded"
else
  echo "no changes"
fi

echo "done"
