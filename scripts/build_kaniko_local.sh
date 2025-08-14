#!/usr/bin/env bash
set -euo pipefail

# Local Kaniko build example. By default, it does not push.
# To push, set DESTINATION (e.g., ghcr.io/OWNER/containers-build-showdown/app:kaniko)
DESTINATION=${DESTINATION:-}
DOCKERFILE=${DOCKERFILE:-containers/kaniko/Dockerfile}
CONTEXT=${CONTEXT:-.}
TAR_PATH=${TAR_PATH:-$(pwd)/app-kaniko.tar}

CMD=(/kaniko/executor "--dockerfile=$DOCKERFILE" "--context=dir://$CONTEXT")
if [[ -n "$DESTINATION" ]]; then
  CMD+=("--destination=$DESTINATION")
else
  CMD+=("--no-push" "--tar-path=/workspace/app-kaniko.tar")
fi

# Use Docker (or Podman) to run Kaniko executor with the repo mounted
if command -v docker >/dev/null 2>&1; then
  RUNTIME=docker
elif command -v podman >/dev/null 2>&1; then
  RUNTIME=podman
else
  echo "Neither docker nor podman found to run Kaniko executor"
  exit 1
fi

$RUNTIME run --rm -v "$(pwd)":/workspace gcr.io/kaniko-project/executor:latest "${CMD[@]}"

if [[ -z "$DESTINATION" ]]; then
  echo "Kaniko build artifact saved to $TAR_PATH"
  if [[ "$RUNTIME" == "docker" ]]; then
    echo "Load into Docker: docker load -i app-kaniko.tar"
  fi
fi
