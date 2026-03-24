#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCE_OPENAPI="${ROOT}/neptune-contracts/openapi/openapi.yaml"
DOC_OPENAPI="${ROOT}/docs-linhay/api/openapi.yaml"

if [[ ! -f "${SOURCE_OPENAPI}" ]]; then
  echo "[contract-parity] missing ${SOURCE_OPENAPI}" >&2
  exit 1
fi

if [[ ! -f "${DOC_OPENAPI}" ]]; then
  echo "[contract-parity] missing ${DOC_OPENAPI}" >&2
  exit 1
fi

ruby - <<'RUBY' "${SOURCE_OPENAPI}" "${DOC_OPENAPI}"
require 'yaml'
require 'set'

expected_paths = Set[
  '/v2/logs:ingest',
  '/v2/logs',
  '/v2/metrics',
  '/v2/sources',
  '/v2/health',
  '/v2/gateway/discovery'
]

ARGV.each do |path|
  doc = YAML.load_file(path)
  paths = Set.new((doc['paths'] || {}).keys)
  missing = expected_paths - paths

  unless missing.empty?
    abort "[contract-parity] #{path} missing paths: #{missing.to_a.join(', ')}"
  end

  if paths.include?('/v2/ws')
    abort "[contract-parity] #{path} still contains /v2/ws"
  end
end
RUBY

if ! diff -q "${SOURCE_OPENAPI}" "${DOC_OPENAPI}" >/dev/null; then
  echo "[contract-parity] docs-linhay/api/openapi.yaml is out of sync with neptune-contracts/openapi/openapi.yaml" >&2
  exit 1
fi

echo "[contract-parity] ok"
