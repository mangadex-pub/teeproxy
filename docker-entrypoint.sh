#!/usr/bin/env bash

set -euo pipefail

ARGS=()

LISTEN_ADDR="${LISTEN_ADDR:-"0.0.0.0:8080"}"
echo "Setting listen address: $LISTEN_ADDR"
ARGS+=("-l" "$LISTEN_ADDR")

TARGET_PRIMARY="${TARGET_PRIMARY:-"http://primary.local:8081"}"
echo "Adding primary target: $TARGET_PRIMARY"
ARGS+=("-a" "$TARGET_PRIMARY")

TARGET_REPLICAS="${TARGET_REPLICAS:-"http://replicas-0.local:8081 http://replicas-1.local:8081 http://replicas-2.local:8081"}"
echo "Adding replica targets..."
for TARGET_REPLICA in $TARGET_REPLICAS; do
  echo "+ $TARGET_REPLICA"
  ARGS+=("-b" "$TARGET_REPLICA")
done

EXTRA_ARGS="${EXTRA_ARGS:-}"
echo "Adding extra args..."
for EXTRA_ARG in $EXTRA_ARGS; do
  ARGS+=("$EXTRA_ARG")
done

set -x
exec teeproxy "${ARGS[@]}"
