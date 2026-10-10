#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  [*] Launching Flow Flutter Application"
echo "=================================================="

flutter pub get
flutter run -d chrome || flutter run
