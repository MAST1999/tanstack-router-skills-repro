#!/usr/bin/env bash
# Packs the stub package with react-router's exact files field, before and
# after the one-line fix, and counts skills/ entries in each tarball.
set -euo pipefail
cd "$(dirname "$0")"
for variant in before after; do
  (cd "$variant" && npm pack --silent --pack-destination .. >/dev/null)
  COUNT=$(tar tzf stub-react-router-0.0.0.tgz | grep -c 'skills/' || true)
  rm stub-react-router-0.0.0.tgz
  echo "$variant: tarball skills/ entries = $COUNT"
done
