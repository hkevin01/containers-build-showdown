#!/usr/bin/env bash
set -euo pipefail
docker rm -f buildshow-app >/dev/null 2>&1 || true
docker image rm buildshow/app:docker buildshow/app:buildkit >/dev/null 2>&1 || true
if command -v podman >/dev/null 2>&1; then
  podman image rm buildshow/app:podman >/dev/null 2>&1 || true
fi
rm -f app-kaniko.tar
echo "Cleaned local artifacts"
