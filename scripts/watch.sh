#!/bin/bash

set -eo pipefail

# set this based on dev/prod
git ls-files | entr -c ./scripts/local.sh
