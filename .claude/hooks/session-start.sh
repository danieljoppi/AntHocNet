#!/usr/bin/env bash
# SessionStart hook (#618): make every check in AGENTS.md runnable from a fresh
# Claude Code on the web container, at the versions CI pins.
#
#   always:        ruff, mkdocs-material, pyyaml (from requirements/, hash-checked)
#   AHN_WEB=1:     emsdk at CI's pinned version + playwright-core/axe-core
#                  (for web/test/parity.sh and web/test/smoke.mjs)
#
# A no-op outside cloud sessions (CLAUDE_CODE_REMOTE unset): local machines
# manage their own toolchains. Idempotent and quiet; never fails the session.
set -u
[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0
cd "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}" || exit 0
log() { echo "[session-start] $*" >&2; }

# Python tooling, pinned by the same hashed requirements CI uses.
need=""
for t in ruff mkdocs; do command -v "$t" >/dev/null 2>&1 || need="$need $t"; done
python3 -c 'import yaml' 2>/dev/null || need="$need pyyaml"
if [ -n "$need" ]; then
    log "installing:$need"
    pip install -q --require-hashes -r requirements/ruff.txt -r requirements/mkdocs-material.txt \
        -r requirements/pyyaml.txt >/dev/null 2>&1 \
        || log "pip install failed; run: pip install --require-hashes -r requirements/ruff.txt -r requirements/mkdocs-material.txt -r requirements/pyyaml.txt"
fi

# Browser toolchain, opt-in (it is large).
if [ "${AHN_WEB:-0}" = "1" ]; then
    # The emsdk pin is the setup-emsdk action's default (#610).
    ver=$(grep -oE "default: '[0-9.]+'" .github/actions/setup-emsdk/action.yml | head -n 1 | tr -dc '0-9.')
    ver=${ver:-4.0.10}
    em="$HOME/.cache/emsdk"
    if [ ! -x "$em/upstream/emscripten/emcc" ]; then
        log "installing emsdk $ver into $em"
        git clone -q --depth 1 --branch "$ver" https://github.com/emscripten-core/emsdk.git "$em" \
            && "$em/emsdk" install "$ver" >/dev/null && "$em/emsdk" activate "$ver" >/dev/null \
            || log "emsdk install failed"
    fi
    pw="$HOME/.cache/ahn-node"
    if [ ! -d "$pw/node_modules/playwright-core" ]; then
        # The same lockfile CI installs with npm ci (#787).
        mkdir -p "$pw" && cp web/test/browser-tools/package.json web/test/browser-tools/package-lock.json "$pw/" \
            && (cd "$pw" && npm ci -s --no-audit --no-fund >/dev/null 2>&1) \
            || log "npm ci failed"
    fi
    log "web: source $em/emsdk_env.sh; run the smoke from $pw (see the learn-site skill)"
fi
exit 0
