#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RUN_HARMONY_BUILD="${NEPTUNE_DEMO_HARMONY_BUILD:-0}"
CHECK_ANDROID_SIM="${NEPTUNE_CHECK_ANDROID_SIM:-0}"
CHECK_HARMONY_SIM="${NEPTUNE_CHECK_HARMONY_SIM:-0}"
ANDROID_SDK_PATH="${ANDROID_SDK_ROOT:-/opt/homebrew/share/android-commandlinetools}"
HDC_BIN="${NEPTUNE_HDC_BIN:-/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc}"

run_repo_cmd() {
  local repo="$1"
  shift
  printf '\n===== %s =====\n' "$repo"
  (cd "${ROOT}/${repo}" && "$@")
}

check_android_simulator() {
  local adb_bin
  local serial

  if [[ -x "${ANDROID_SDK_PATH}/platform-tools/adb" ]]; then
    adb_bin="${ANDROID_SDK_PATH}/platform-tools/adb"
  elif command -v adb >/dev/null 2>&1; then
    adb_bin="$(command -v adb)"
  else
    echo "[android-sim] adb not found" >&2
    return 1
  fi

  serial="$("${adb_bin}" devices | awk '$2=="device" && $1 ~ /emulator-/ {print $1; exit}')"
  if [[ -z "${serial}" ]]; then
    echo "[android-sim] no online emulator device, skip realtime install/start" >&2
    return 1
  fi

  printf '[android-sim] using device %s\n' "${serial}"
  (
    cd "${ROOT}/neptune-sdk-android/examples/simulator-app"
    ANDROID_HOME="${ANDROID_SDK_PATH}" ANDROID_SDK_ROOT="${ANDROID_SDK_PATH}" ./gradlew :app:installDebug
    "${adb_bin}" -s "${serial}" shell am start -n com.neptunekit.sdk.android.examples.simulator/.MainActivity
    "${adb_bin}" -s "${serial}" shell dumpsys activity activities | rg -n "ResumedActivity" -N | head -n 1
  )
}

check_harmony_simulator() {
  if [[ ! -x "${HDC_BIN}" ]]; then
    echo "[harmony-sim] hdc not found at ${HDC_BIN}" >&2
    return 1
  fi

  "${HDC_BIN}" list targets
  "${HDC_BIN}" shell aa start -b io.github.neptune.sdk.harmony -m entry -a EntryAbility
}

printf '[smoke-demo-android-harmony] running android/harmony smoke demos\n'

run_repo_cmd neptune-sdk-android ./gradlew smokeDemo
run_repo_cmd neptune-sdk-harmony node ./scripts/demo-smoke.mjs

if [[ "${RUN_HARMONY_BUILD}" == "1" ]]; then
  run_repo_cmd neptune-sdk-harmony ohpm install --all
  run_repo_cmd neptune-sdk-harmony ./hvigorw --mode module -p module=library assembleHar --no-daemon
fi

if [[ "${CHECK_ANDROID_SIM}" == "1" ]]; then
  check_android_simulator
fi

if [[ "${CHECK_HARMONY_SIM}" == "1" ]]; then
  check_harmony_simulator
fi

printf '\n[smoke-demo-android-harmony] android/harmony smoke demos passed\n'
