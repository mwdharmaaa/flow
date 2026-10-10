#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Building Flow Standalone APK"
echo "=================================================="

bash deploy.sh

if command -v ./android/gradlew >/dev/null 2>&1; then
  echo "[*] Building local APK via Gradle..."
  cd android
  ./gradlew assembleDebug
  cd ..
  mkdir -p build-output
  cp android/app/build/outputs/apk/debug/app-debug.apk build-output/flow.apk
  echo "[OK] Local APK created at: build-output/flow.apk"
else
  echo "[*] Triggering automated GitHub Actions APK builder..."
  git push origin devv
  echo "[OK] Pushed to GitHub. GitHub Actions is building the APK."
  echo "[*] Check status with: gh run list --workflow=build-apk.yml"
fi
