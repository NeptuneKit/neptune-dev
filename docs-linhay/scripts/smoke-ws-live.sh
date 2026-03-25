#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PORT="${NEPTUNE_WS_SMOKE_PORT:-19001}"
BASE_URL="${NEPTUNE_WS_BASE_URL:-http://127.0.0.1:${PORT}}"
LOG_FILE="${NEPTUNE_WS_SMOKE_LOG:-/tmp/neptune-gateway-ws-live-smoke.log}"

resolve_swift() {
  if command -v xcrun >/dev/null 2>&1; then
    xcrun --find swift
    return
  fi
  command -v swift
}

wait_health() {
  local retries=80
  local interval=0.2
  for ((i=0; i<retries; i++)); do
    if curl -fsS "${BASE_URL}/v2/health" >/dev/null 2>&1; then
      return 0
    fi
    sleep "${interval}"
  done
  return 1
}

if lsof -nP -iTCP:"${PORT}" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "[ws-live-smoke] port ${PORT} is already in use, set NEPTUNE_WS_SMOKE_PORT to another value" >&2
  exit 1
fi

SWIFT_BIN="$(resolve_swift)"

echo "[ws-live-smoke] building gateway debug binary"
(cd "${ROOT}/neptune-gateway-swift" && "${SWIFT_BIN}" build >/dev/null)

GATEWAY_BIN="${ROOT}/neptune-gateway-swift/.build/debug/neptune-gateway"
if [[ ! -x "${GATEWAY_BIN}" ]]; then
  echo "[ws-live-smoke] gateway binary missing: ${GATEWAY_BIN}" >&2
  exit 1
fi

echo "[ws-live-smoke] starting gateway at ${BASE_URL}"
"${GATEWAY_BIN}" serve --port "${PORT}" >"${LOG_FILE}" 2>&1 &
GW_PID=$!
trap 'kill "${GW_PID}" >/dev/null 2>&1 || true' EXIT

if ! wait_health; then
  echo "[ws-live-smoke] gateway health timeout" >&2
  tail -n 120 "${LOG_FILE}" >&2 || true
  exit 1
fi

echo "[ws-live-smoke] running ws dispatch smoke"
NEPTUNE_WS_BASE="${BASE_URL}" node <<'NODE'
const base = process.env.NEPTUNE_WS_BASE ?? 'http://127.0.0.1:19001';
const wsURL = new URL('/v2/ws', base);
wsURL.protocol = wsURL.protocol === 'https:' ? 'wss:' : 'ws:';

const requestId = `live-${Date.now()}`;
const targetPlatforms = ['ios', 'harmony'];

function waitOpen(ws, timeoutMs = 4000) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error('open timeout')), timeoutMs);
    ws.addEventListener('open', () => {
      clearTimeout(timer);
      resolve();
    }, { once: true });
    ws.addEventListener('error', () => {
      clearTimeout(timer);
      reject(new Error('websocket error'));
    }, { once: true });
  });
}

function makeSdk(platform) {
  const ws = new WebSocket(wsURL);
  ws.addEventListener('message', (event) => {
    let frame;
    try { frame = JSON.parse(String(event.data)); } catch { return; }
    if (frame.type === 'command.dispatch' && frame.command === 'ping') {
      ws.send(JSON.stringify({
        type: 'command.ack',
        requestId: frame.requestId,
        commandId: frame.commandId,
        command: 'ping',
        status: 'ok',
        timestamp: new Date().toISOString(),
      }));
    }
  });
  return { ws, platform };
}

async function main() {
  const sdkClients = [makeSdk('ios'), makeSdk('android'), makeSdk('harmony')];
  await Promise.all(sdkClients.map((c) => waitOpen(c.ws)));
  for (const c of sdkClients) {
    c.ws.send(JSON.stringify({
      type: 'hello',
      role: 'sdk',
      platform: c.platform,
      appId: 'smoke.app',
      sessionId: `session-${c.platform}`,
      deviceId: `device-${c.platform}`,
    }));
  }

  const inspector = new WebSocket(wsURL);
  await waitOpen(inspector);
  inspector.send(JSON.stringify({ type: 'hello', role: 'inspector' }));

  const frames = [];
  const summary = await new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error('summary timeout')), 12000);
    inspector.addEventListener('message', (event) => {
      let frame;
      try { frame = JSON.parse(String(event.data)); } catch { return; }
      frames.push(frame);
      if (frame.type === 'event.command_summary' && frame.requestId === requestId) {
        clearTimeout(timer);
        resolve(frame);
      }
    });

    setTimeout(() => {
      inspector.send(JSON.stringify({
        type: 'command.send',
        requestId,
        command: 'ping',
        target: { platforms: targetPlatforms },
      }));
    }, 250);
  });

  const acceptedAck = frames.find((f) => f.type === 'ack' && f.requestId === requestId);
  const ackEvents = frames.filter((f) => f.type === 'event.command_ack' && f.requestId === requestId);

  const output = {
    requestId,
    targetPlatforms,
    acceptedAck,
    ackEventsCount: ackEvents.length,
    summary,
  };
  console.log(JSON.stringify(output, null, 2));

  if (!acceptedAck || acceptedAck.delivered !== 2) {
    throw new Error('accepted ack mismatch');
  }
  if (ackEvents.length !== 2) {
    throw new Error('ack event count mismatch');
  }
  if (summary.delivered !== 2 || summary.acked !== 2 || summary.timeout !== 0) {
    throw new Error('summary mismatch');
  }

  inspector.close();
  for (const c of sdkClients) {
    c.ws.close();
  }
}

main().catch((error) => {
  console.error(String(error?.message ?? error));
  process.exit(1);
});
NODE

echo "[ws-live-smoke] passed"
