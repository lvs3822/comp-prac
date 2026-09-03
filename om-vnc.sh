#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-om-gui:1.27.0}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    docker build -t "$IMAGE" "$DIR"
fi

docker run --rm -it --name om-gui \
    -p 127.0.0.1:6080:6080 \
    -p 127.0.0.1:5900:5900 \
    -v "$HOME:$HOME" -e "HOME=$HOME" -w "$PWD" \
    --shm-size=1g \
    "$IMAGE" "$@"
