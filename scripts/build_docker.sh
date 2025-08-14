#!/usr/bin/env bash
set -euo pipefail
IMAGE=${IMAGE:-buildshow/app:docker}
docker build --no-cache -t "$IMAGE" -f containers/docker/Dockerfile .
echo "Built $IMAGE"
