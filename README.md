# `@tanstack/react-router` agent skills are authored but never published

Minimal reproduction for the TanStack Router issue: **`packages/react-router/skills/` exists and is actively maintained on `main` (skills `react-router`, `compositions`, `lifecycle`), but the published npm package never contains it** — `packages/react-router/package.json#files` is `["dist", "src"]`.

Result: agent tooling that discovers skills from installed packages (e.g. `@tanstack/intent`) can never see react-router's skills, no matter the version. The sibling package `@tanstack/router-core` ships its `skills/` directory correctly, so react-router's omission looks unintentional.

## Run it

```sh
./repro.sh
```

Expected vs actual (captured 2026-10-17, `@tanstack/react-router@1.170.45`):

```
== @tanstack/react-router: version + files field ==
1.170.45 ["dist","src"]

== skills/ entries in @tanstack/react-router (ACTUAL) ==
  (none — the directory does not exist in the installed package)

== skills/ entries in @tanstack/router-core (the shipped precedent) ==
  node_modules/@tanstack/router-core/skills/router-core/SKILL.md
  node_modules/@tanstack/router-core/skills/router-core/auth-and-guards/SKILL.md
  node_modules/@tanstack/router-core/skills/router-core/code-splitting/SKILL.md
  node_modules/@tanstack/router-core/skills/router-core/data-loading/SKILL.md
  node_modules/@tanstack/router-core/skills/router-core/navigation/SKILL.md
  node_modules/@tanstack/router-core/skills/router-core/not-found-and-errors/SKILL.md
  node_modules/@tanstack/router-core/skills/router-core/path-params/SKILL.md
  node_modules/@tanstack/router-core/skills/router-core/search-params/SKILL.md

== registry tarball check: react-router@latest ==
  tarball skills/ entries: 0
```

## The fix, proved without cloning the monorepo

`mock-pack/` reproduces the publish step with a stub package carrying react-router's exact `files` field, and packs it **before** (`["dist","src"]`) and **after** (`["dist","src","skills"]`) the one-line fix:

```sh
./mock-pack/pack.sh
```

- **before**: tarball contains 0 `skills/` entries (the current published behavior)
- **after**: tarball contains 3 `skills/` entries

Upstream fix (`packages/react-router/package.json`):

```diff
   "files": [
     "dist",
-    "src"
+    "src",
+    "skills"
   ],
```
