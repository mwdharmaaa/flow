#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Clean Rebuilding Flow Assets"
echo "=================================================="

rm -rf dist
bash deploy.sh

echo "[OK] Redeployment completed successfully."
