#!/bin/bash

set -eo pipefail

git ls-files | entr -c ./scripts/deploy.sh