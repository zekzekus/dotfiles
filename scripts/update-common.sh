#!/usr/bin/env bash
# Shared download/error handling for the four pinned-package updaters.
# Sourced after nix_file is set; never writes the pin until install_pin.

updater=$(basename "$0")
fail() { echo "$updater: $*" >&2; exit 1; }
trap 'echo "$updater: failed at line $LINENO (exit $?)" >&2' ERR

: "${nix_file:?caller must set nix_file before sourcing update-common.sh}"
[[ -f "$nix_file" ]] || fail "$nix_file not found"
work=$(mktemp -d "$(dirname "$nix_file")/.update-XXXXXX")
trap 'rm -rf "$work"' EXIT

fetch() {
  # curl retries timeouts, 408/429/5xx responses and refused connections, not
  # permanent HTTP errors. Keep each attempt and the retry window bounded.
  curl --fail --silent --show-error --location \
    --retry 4 --retry-connrefused --retry-max-time 600 \
    --connect-timeout 15 --max-time 300 "$@"
}

github_tag() {
  local token=${GH_TOKEN:-${GITHUB_TOKEN:-}}
  local header=""
  # Feed the optional credential through stdin, not process arguments/logs.
  [[ "$token" != *[!a-zA-Z0-9_]* ]] || fail "invalid GitHub token format"
  [[ -z "$token" ]] || header="header = \"Authorization: Bearer $token\""
  if ! printf '%s\n' "$header" \
    | fetch --config - "$1" --output "$work/release.json"; then
    fail "GitHub release lookup failed: $1 (check service status or API rate limits; GH_TOKEN/GITHUB_TOKEN is optional)"
  fi
  if ! python3 -c '
import json, sys
tag = json.load(sys.stdin)["tag_name"]
if not isinstance(tag, str) or not tag:
    raise ValueError("missing nonempty tag_name")
print(tag)
' < "$work/release.json"; then
    fail "invalid GitHub release JSON or missing tag_name: $1"
  fi
}

download_hash() {
  fetch "$1" --output "$work/archive" || { fail "archive download failed: $1; pin unchanged"; }
  nix hash file --type sha256 --sri "$work/archive"
}

install_pin() {
  chmod 644 "$work/pin"
  mv "$work/pin" "$nix_file"
  echo "Wrote $nix_file"
}
