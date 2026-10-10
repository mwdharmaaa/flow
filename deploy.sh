#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Deploying / Building Flow Flutter"
echo "=================================================="

flutter pub get
flutter build apk --release --no-tree-shake-icons

echo "[OK] Deployment build completed successfully."
