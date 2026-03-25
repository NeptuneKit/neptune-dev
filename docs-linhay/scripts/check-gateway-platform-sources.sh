#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-http://127.0.0.1:18765}"

payload="$(curl -fsS "$BASE_URL/v2/sources")"

node - "$payload" <<'NODE'
const payload = JSON.parse(process.argv[2]);
const items = Array.isArray(payload.items) ? payload.items : [];
const platforms = new Set(items.map((item) => item.platform));
const required = ["ios", "android", "harmony"];
const missing = required.filter((p) => !platforms.has(p));

console.log(`sources.count=${items.length}`);
console.log(`sources.platforms=${Array.from(platforms).sort().join(",")}`);

if (missing.length > 0) {
  console.error(`missing.platforms=${missing.join(",")}`);
  process.exit(1);
}

console.log("gateway-platform-sources: ok");
NODE
