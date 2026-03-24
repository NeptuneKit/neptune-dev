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

check_contract_fixtures() {
  local dir="${ROOT}/neptune-contracts/fixtures"
  ruby - <<'RUBY' "${dir}"
require 'json'
require 'pathname'

fixtures = Pathname(ARGV[0])

Dir.glob(fixtures.join('*.json').to_s).sort.each do |path|
  JSON.parse(File.read(path))
end

Dir.glob(fixtures.join('*.ndjson').to_s).sort.each do |path|
  File.readlines(path, chomp: true).each_with_index do |line, index|
    next if line.strip.empty?
    JSON.parse(line)
  rescue JSON::ParserError => e
    abort "invalid ndjson: #{path}:#{index + 1} #{e.message}"
  end
end
RUBY
}

SWIFT_BIN="$(resolve_swift)"

bash "${ROOT}/docs-linhay/scripts/check-log-contract-parity.sh"
check_contract_fixtures

run neptune-gateway-swift "\"${SWIFT_BIN}\" test"
run neptune-sdk-ios "xcrun swift test"
run neptune-sdk-android "./gradlew test && ./gradlew smokeDemo"
run neptune-sdk-harmony "if [[ -f scripts/sync-harmony-module.sh ]]; then sh -n scripts/sync-harmony-module.sh; fi && bash -n scripts/verify-sources-endpoint.sh && node scripts/verify-source-dedup.mjs && node scripts/verify-log-query-filtering.mjs && node scripts/verify-log-persistence.mjs && node scripts/demo-smoke.mjs"
run neptune-sdk-web "npm test && npm run build"
run neptune-inspector-h5 "npm test && npm run build"

echo "\nAll logging checks passed."
