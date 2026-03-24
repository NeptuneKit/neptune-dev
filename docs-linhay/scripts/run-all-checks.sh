#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

run() {
  local repo="$1"
  local cmd="$2"
  echo "\n===== ${repo} ====="
  (cd "${ROOT}/${repo}" && eval "${cmd}")
}

run neptune-gateway-swift "swift test"
run neptune-sdk-ios "xcrun swift test"
run neptune-sdk-android "./gradlew test"
run neptune-inspector-h5 "npm test && npm run build"
run neptune-sdk-web "npm test && npm run build"
run neptune-sdk-harmony "bash -n scripts/verify-sources-endpoint.sh && node scripts/verify-source-dedup.mjs && node scripts/verify-log-query-filtering.mjs && node scripts/verify-log-persistence.mjs"
run neptune-desktop-macos "swift build"

if [[ "${NEPTUNE_CHECK_HARMONY_BUILD:-0}" == "1" ]]; then
  run neptune-sdk-harmony "ohpm install --all && ./hvigorw --mode module -p module=library assembleHar --no-daemon"
fi

echo "\nAll core checks passed."
