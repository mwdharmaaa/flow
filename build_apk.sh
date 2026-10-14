#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Building Flow Standalone APK via Flutter"
echo "=================================================="

if command -v flutter >/dev/null 2>&1; then
  echo "[*] Building lightweight release APK with Flutter..."
  if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
    if ! grep -q "RECORD_AUDIO" android/app/src/main/AndroidManifest.xml; then
      sed -i 's/<application/<uses-permission android:name="android.permission.RECORD_AUDIO" \/>\n    <queries><intent><action android:name="android.speech.RecognitionService" \/><\/intent><\/queries>\n    <application/' android/app/src/main/AndroidManifest.xml
      echo "[OK] Injected speech permissions into AndroidManifest.xml"
    fi
  fi
  flutter pub get
  flutter build apk --release --split-per-abi || flutter build apk --release --no-tree-shake-icons
  mkdir -p build-output
  cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk build-output/flow.apk 2>/dev/null || cp build/app/outputs/flutter-apk/app-release.apk build-output/flow.apk
  echo "[OK] Lightweight APK created at: build-output/flow.apk"
else
  echo "[*] Triggering automated GitHub Actions APK builder..."
  git push origin devv
  echo "[OK] Pushed to GitHub. Check status with: gh run list --workflow=build-apk.yml"
fi
