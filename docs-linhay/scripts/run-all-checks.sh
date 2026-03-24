#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

resolve_swift() {
  if command -v xcrun >/dev/null 2>&1; then
    xcrun --find swift
    return
  fi
  command -v swift
}

yaml_syntax_check() {
  local file="$1"
  if [[ -f "${ROOT}/${file}" ]]; then
    ruby -e 'require "yaml"; YAML.load_file(ARGV[0])' "${ROOT}/${file}" >/dev/null
  fi
}

run() {
  local repo="$1"
  local cmd="$2"
  echo "\n===== ${repo} ====="
  (cd "${ROOT}/${repo}" && eval "${cmd}")
}

SWIFT_BIN="$(resolve_swift)"

yaml_syntax_check neptune-gateway-swift/.github/workflows/release-cli.yml
yaml_syntax_check neptune-gateway-swift/.github/workflows/release-cli-tag.yml
yaml_syntax_check neptune-desktop-macos/.github/workflows/package-desktop.yml
yaml_syntax_check neptune-desktop-macos/.github/workflows/release-desktop.yml
yaml_syntax_check .github/workflows/release-orchestrator.yml

bash "${ROOT}/docs-linhay/scripts/check-log-contract-parity.sh"

run neptune-gateway-swift "\"${SWIFT_BIN}\" test"
run neptune-sdk-ios "xcrun swift test"
run neptune-sdk-android "./gradlew test"
run neptune-inspector-h5 "npm test && npm run build"
run neptune-sdk-web "npm test && npm run build"
run neptune-sdk-harmony "if [[ -f scripts/sync-harmony-module.sh ]]; then sh -n scripts/sync-harmony-module.sh; fi && bash -n scripts/verify-sources-endpoint.sh && node scripts/verify-source-dedup.mjs && node scripts/verify-log-query-filtering.mjs && node scripts/verify-log-persistence.mjs"
run neptune-desktop-macos "\"${SWIFT_BIN}\" build"

if [[ "${NEPTUNE_CHECK_HARMONY_BUILD:-0}" == "1" ]]; then
  run neptune-sdk-harmony "ohpm install --all && ./hvigorw --mode module -p module=library assembleHar --no-daemon"
fi

if [[ "${NEPTUNE_CHECK_ANDROID_HARMONY_SMOKE:-0}" == "1" ]]; then
  (cd "${ROOT}" && bash docs-linhay/scripts/smoke-demo-android-harmony.sh)
fi

if [[ "${NEPTUNE_CHECK_NATIVE_SMOKE:-0}" == "1" ]]; then
  (cd "${ROOT}" && bash docs-linhay/scripts/smoke-demo-native.sh)
fi

if [[ "${NEPTUNE_CHECK_WEB_SMOKE:-0}" == "1" ]]; then
  (cd "${ROOT}" && bash docs-linhay/scripts/smoke-demo-web.sh)
fi

echo "\nAll core checks passed."
