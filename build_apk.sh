#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Building Flow Standalone APK via Flutter"
echo "=================================================="

if command -v flutter >/dev/null 2>&1; then
  echo "[*] Building local APK with Flutter..."
  flutter pub get
  flutter build apk --release --no-tree-shake-icons
  mkdir -p build-output
  cp build/app/outputs/flutter-apk/app-release.apk build-output/flow.apk
  echo "[OK] Local APK created at: build-output/flow.apk"
else
  echo "[*] Triggering automated GitHub Actions APK builder..."
  git push origin devv
  echo "[OK] Pushed to GitHub. Check status with: gh run list --workflow=build-apk.yml"
fi
