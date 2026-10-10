#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Clean Rebuilding Flow Flutter"
echo "=================================================="

rm -rf build
bash deploy.sh

echo "[OK] Redeployment completed successfully."
