#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

run_ios() {
  echo "[discovery] neptune-sdk-ios: xcrun swift test"
  (cd "$ROOT/neptune-sdk-ios" && xcrun swift test)
}

run_android() {
  echo "[discovery] neptune-sdk-android: ./gradlew :sdk:test"
  (cd "$ROOT/neptune-sdk-android" && ./gradlew :sdk:test)
}

run_harmony() {
  echo "[discovery] neptune-sdk-harmony: gateway discovery check"
  (cd "$ROOT/neptune-sdk-harmony" && node ./scripts/verify-gateway-discovery.mjs)
}

run_ios
run_android
run_harmony

echo "[discovery] all checks passed"
