#!/bin/bash

set -eo pipefail

if [ -z "$PROD" ]; then
  git ls-files | entr -c ./scripts/trigger.sh
else
  git ls-files | entr -c ./scripts/deploy.sh
fi
