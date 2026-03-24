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

SWIFT_BIN="$(resolve_swift)"
PORT="${NEPTUNE_DEMO_GATEWAY_PORT:-18765}"
HOST="127.0.0.1"
BASE_URL="http://${HOST}:${PORT}"
LOG_FILE="$(mktemp "${TMPDIR:-/tmp}/neptune-gateway-demo-smoke.XXXXXX")"
GATEWAY_PID=""

cleanup() {
  if [[ -n "${GATEWAY_PID}" ]] && kill -0 "${GATEWAY_PID}" >/dev/null 2>&1; then
    kill "${GATEWAY_PID}" >/dev/null 2>&1 || true
    wait "${GATEWAY_PID}" >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT

printf '[smoke-demo-web] starting gateway at %s\n' "${BASE_URL}"
(
  cd "${ROOT}/neptune-gateway-swift"
  NEPTUNE_HOST="${HOST}" \
  NEPTUNE_PORT="${PORT}" \
  "${SWIFT_BIN}" run neptune-gateway serve
) >"${LOG_FILE}" 2>&1 &
GATEWAY_PID="$!"

ready="0"
for _ in $(seq 1 240); do
  if curl -fsS "${BASE_URL}/v2/health" >/dev/null 2>&1; then
    ready="1"
    break
  fi

  if ! kill -0 "${GATEWAY_PID}" >/dev/null 2>&1; then
    printf '[smoke-demo-web] gateway exited unexpectedly\n' >&2
    cat "${LOG_FILE}" >&2
    exit 1
  fi

  sleep 1
done

if [[ "${ready}" != "1" ]]; then
  printf '[smoke-demo-web] gateway health timeout\n' >&2
  cat "${LOG_FILE}" >&2
  exit 1
fi

printf '[smoke-demo-web] gateway healthy, running web sdk demo\n'
(
  cd "${ROOT}/neptune-sdk-web"
  if [[ ! -d node_modules ]]; then
    npm ci >/dev/null
  fi
  npm run build >/dev/null
  NEPTUNE_GATEWAY_BASE_URL="${BASE_URL}" node examples/smoke-demo/run.cjs
)

printf '[smoke-demo-web] smoke passed\n'
