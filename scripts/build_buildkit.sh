#!/usr/bin/env bash
set -euo pipefail
IMAGE=${IMAGE:-buildshow/app:buildkit}
# Buildx uses BuildKit under the hood
docker buildx create --use --name buildshow-box >/dev/null 2>&1 || true
docker buildx build \
  --load \
  -t "$IMAGE" \
  -f containers/buildkit/Dockerfile \
  --secret id=npmrc,src=.npmrc \
  .
echo "Built $IMAGE via Buildx/BuildKit"
