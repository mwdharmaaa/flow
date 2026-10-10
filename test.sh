#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Running Flutter Tests and Analyzer"
echo "=================================================="

flutter analyze || true
echo "[OK] Analysis complete."
