#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RUN_HARMONY_BUILD="${NEPTUNE_DEMO_HARMONY_BUILD:-0}"

run() {
  local name="$1"
  shift
  printf '\n===== %s =====\n' "$name"
  (cd "$ROOT/$name" && "$@")
}

printf '[smoke-demo-native] running ios/android/harmony smoke demos\n'

run neptune-sdk-ios ./scripts/smoke-demo.sh
run neptune-sdk-android ./gradlew smokeDemo
run neptune-sdk-harmony node ./scripts/demo-smoke.mjs

if [[ "$RUN_HARMONY_BUILD" == "1" ]]; then
  run neptune-sdk-harmony ohpm install --all
  run neptune-sdk-harmony ./hvigorw --mode module -p module=library assembleHar --no-daemon
fi

printf '\n[smoke-demo-native] all native smoke demos passed\n'
