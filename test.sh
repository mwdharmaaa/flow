#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Running Flow Test Suite"
echo "=================================================="

npm run build
echo "[OK] TypeScript and Vite bundle checks passed."
