#!/usr/bin/env bash
# Minimal reproduction: @tanstack/react-router authors agent skills in
# packages/react-router/skills on main, but the published npm package never
# delivers them — package.json#files is ["dist", "src"].
#
# Contrast: @tanstack/router-core ships its skills/ just fine.

set -euo pipefail

PKG_DIR="node_modules/@tanstack/react-router"
CORE_DIR="node_modules/@tanstack/router-core"

echo "== fresh install =="
npm install --no-audit --no-fund @tanstack/react-router

echo
echo "== @tanstack/react-router: version + files field =="
node -e "const p = require('./$PKG_DIR/package.json'); console.log(p.version, JSON.stringify(p.files))"

echo
echo "== skills/ entries in @tanstack/react-router (ACTUAL) =="
if [ -d "$PKG_DIR/skills" ]; then
  find "$PKG_DIR/skills" -name "SKILL.md" | sed 's/^/  /'
else
  echo "  (none — the directory does not exist in the installed package)"
fi

echo
echo "== skills/ entries in @tanstack/router-core (the shipped precedent) =="
if [ -d "$CORE_DIR/skills" ]; then
  find "$CORE_DIR/skills" -name "SKILL.md" | sed 's/^/  /'
else
  echo "  (none)"
fi

echo
echo "== registry tarball check: react-router@latest =="
VER=$(node -e "console.log(require('./$PKG_DIR/package.json').version)")
curl -sL "https://registry.npmjs.org/@tanstack/react-router/-/react-router-$VER.tgz" -o /tmp/rr.tgz
echo "  tarball skills/ entries: $(tar tzf /tmp/rr.tgz | grep -c 'skills/' || true)"
