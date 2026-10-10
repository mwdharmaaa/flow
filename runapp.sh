#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Launching Flow Personal Finance Tracker"
echo "=================================================="

if [ ! -d "node_modules" ]; then
  echo "[*] Installing dependencies..."
  npm install
fi

echo "[*] Starting local dev server on http://localhost:3000..."
npm run dev -- --host
