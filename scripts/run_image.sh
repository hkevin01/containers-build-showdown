#!/usr/bin/env bash
set -euo pipefail
IMAGE=${1:-buildshow/app:docker}
PORT=${PORT:-3000}
docker run --rm -p "$PORT:3000" "$IMAGE"
