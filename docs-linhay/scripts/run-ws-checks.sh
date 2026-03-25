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

run() {
  local repo="$1"
  local cmd="$2"
  echo "\n===== ${repo} ====="
  (cd "${ROOT}/${repo}" && eval "${cmd}")
}

SWIFT_BIN="$(resolve_swift)"

bash "${ROOT}/docs-linhay/scripts/check-log-contract-parity.sh"

run neptune-gateway-swift "\"${SWIFT_BIN}\" test --filter GatewayRoutesTests/testCommandSendDispatchesToMatchingSdkAndSummarizesAckedCommand"
run neptune-gateway-swift "\"${SWIFT_BIN}\" test --filter GatewayRoutesTests/testWebSocketHelloAndIngestPublishesLogRecordEventToSdk"
run neptune-inspector-h5 "npx vitest run tests/ws.test.ts"
run neptune-sdk-ios "xcrun swift test --filter GatewayWebSocketClientTests"
run neptune-sdk-android "./gradlew :sdk:test --tests com.neptunekit.sdk.android.ws.GatewayWebSocketClientTest --tests com.neptunekit.sdk.android.ws.GatewayWebSocketReconnectPolicyTest"
run neptune-sdk-harmony "node ./scripts/verify-gateway-ws-contract.mjs"

echo "\nWS checks passed."
