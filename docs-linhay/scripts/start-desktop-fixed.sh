#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
APP_PATH="$ROOT/neptune-desktop-macos/.build/artifacts/NeptuneDesktopMacOS.app"
APP_BIN="$APP_PATH/Contents/MacOS/NeptuneDesktopMacOS"
GW_BIN="$ROOT/neptune-gateway-swift/.build/release/neptune-gateway"

PREVIEW_HOST="${NEPTUNE_PREVIEW_HOST:-127.0.0.1}"
PREVIEW_PORT="${NEPTUNE_PREVIEW_PORT:-4173}"
INSPECTOR_URL="${NEPTUNE_INSPECTOR_URL:-http://${PREVIEW_HOST}:${PREVIEW_PORT}}"

PREVIEW_LOG="/tmp/neptune-inspector-preview.log"

echo "[desktop-fixed] root: $ROOT"
echo "[desktop-fixed] inspector: $INSPECTOR_URL"

if [[ ! -x "$APP_BIN" ]]; then
  echo "[desktop-fixed] missing app binary: $APP_BIN" >&2
  exit 1
fi

if [[ ! -x "$GW_BIN" ]]; then
  echo "[desktop-fixed] missing gateway binary: $GW_BIN" >&2
  exit 1
fi

pkill -f "vite preview --host ${PREVIEW_HOST} --port ${PREVIEW_PORT}" || true
if pgrep -f "NeptuneDesktopMacOS.app/Contents/MacOS/NeptuneDesktopMacOS" >/dev/null 2>&1; then
  osascript -e 'tell application "NeptuneDesktopMacOS" to quit' || true
  for _ in $(seq 1 20); do
    if ! pgrep -f "NeptuneDesktopMacOS.app/Contents/MacOS/NeptuneDesktopMacOS" >/dev/null 2>&1; then
      break
    fi
    sleep 0.2
  done
fi
pkill -f "NeptuneDesktopMacOS.app/Contents/MacOS/NeptuneDesktopMacOS" || true
pkill -f "/neptune-gateway-swift/.build/release/neptune-gateway" || true
sleep 1

(
  cd "$ROOT/neptune-inspector-h5"
  nohup npm run preview -- --host "$PREVIEW_HOST" --port "$PREVIEW_PORT" >"$PREVIEW_LOG" 2>&1 &
)
sleep 2

if ! curl -fsS "$INSPECTOR_URL/" >/dev/null; then
  echo "[desktop-fixed] preview not reachable: $INSPECTOR_URL" >&2
  tail -n 80 "$PREVIEW_LOG" || true
  exit 1
fi

# Launch via LaunchServices so the app shows correctly in Dock.
launchctl setenv NEPTUNE_INSPECTOR_URL "$INSPECTOR_URL"
launchctl setenv NEPTUNE_GATEWAY_BIN "$GW_BIN"
open -na "$APP_PATH"
sleep 3

osascript -e 'tell application "NeptuneDesktopMacOS" to activate' || true
sleep 1
osascript <<'APPLESCRIPT' || true
tell application "System Events"
  tell process "NeptuneDesktopMacOS"
    if (count of windows) > 0 then
      set value of attribute "AXMinimized" of window 1 to false
      perform action "AXRaise" of window 1
    end if
  end tell
end tell
APPLESCRIPT

echo "[desktop-fixed] processes:"
pgrep -fal "NeptuneDesktopMacOS.app/Contents/MacOS/NeptuneDesktopMacOS|vite preview --host ${PREVIEW_HOST} --port ${PREVIEW_PORT}|/neptune-gateway-swift/.build/release/neptune-gateway" | sed -n '1,20p'

echo "[desktop-fixed] window count:"
osascript -e 'tell application "System Events" to tell process "NeptuneDesktopMacOS" to count of windows' 2>/dev/null || true

echo "[desktop-fixed] gateway health:"
curl -fsS "http://127.0.0.1:18765/v2/health" || true
echo

echo "[desktop-fixed] done"
