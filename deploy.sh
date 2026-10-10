#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Building Flow Production Assets"
echo "=================================================="

if [ ! -d "node_modules" ]; then
  echo "[*] Installing dependencies..."
  npm install
fi

echo "[*] Compiling TypeScript and Vite bundle..."
npm run build

if [ ! -d "android" ]; then
  echo "[*] Initializing Capacitor Android platform..."
  npx cap add android
fi

echo "[*] Syncing Capacitor native assets..."
npx cap sync android

echo "[OK] Build completed successfully."
