#!/usr/bin/env bash
set -euo pipefail
IMAGE=${IMAGE:-buildshow/app:podman}
podman build -t "$IMAGE" -f containers/podman/Containerfile .
echo "Built $IMAGE via Podman"
