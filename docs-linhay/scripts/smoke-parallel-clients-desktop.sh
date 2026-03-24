#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LOG_DIR="${ROOT}/.build/smoke-logs"

run_in_bg() {
  local name="$1"
  local cmd="$2"
  local pid_var="$3"
  local log_file="${LOG_DIR}/${name}.log"
  local pid

  (
    cd "${ROOT}"
    bash -lc "${cmd}"
  ) >"${log_file}" 2>&1 &
  pid=$!
  printf -v "${pid_var}" '%s' "${pid}"
}

wait_and_report() {
  local name="$1"
  local pid="$2"
  local log_file="${LOG_DIR}/${name}.log"

  if wait "${pid}"; then
    printf '[PASS] %s\n' "${name}"
    return 0
  fi

  printf '[FAIL] %s\n' "${name}" >&2
  printf '%s\n' "--- ${log_file} (tail) ---" >&2
  tail -n 120 "${log_file}" >&2 || true
  return 1
}

mkdir -p "${LOG_DIR}"

printf '[parallel-smoke] logs: %s\n' "${LOG_DIR}"

run_in_bg "native" "bash docs-linhay/scripts/smoke-demo-native.sh" PID_NATIVE
run_in_bg "web" "bash docs-linhay/scripts/smoke-demo-web.sh" PID_WEB
run_in_bg "desktop" "DEV_DIR=\"\$(xcode-select -p)\"; SWIFT_BIN_DIR=\"\$DEV_DIR/Toolchains/XcodeDefault.xctoolchain/usr/bin\"; export PATH=\"\$SWIFT_BIN_DIR:\$DEV_DIR/usr/bin:\$PATH\"; cd neptune-inspector-h5 && ./scripts/build-desktop-assets.sh && cd ../neptune-desktop-macos && ./scripts/package-macos-app.sh --configuration Release --dist ../neptune-inspector-h5/dist --output .build/artifacts/NeptuneDesktopMacOS.app && ./scripts/smoke-test-app.sh --artifact .build/artifacts/NeptuneDesktopMacOS.app --expected-bundle-id com.neptunekit.neptune-desktop-macos" PID_DESKTOP

FAIL=0
wait_and_report "native" "${PID_NATIVE}" || FAIL=1
wait_and_report "web" "${PID_WEB}" || FAIL=1
wait_and_report "desktop" "${PID_DESKTOP}" || FAIL=1

if [[ "${FAIL}" -ne 0 ]]; then
  exit 1
fi

printf '[parallel-smoke] all smoke jobs passed\n'
