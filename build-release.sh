#!/bin/bash
set -e

echo "🔨 Building optimized release APK..."
flutter clean
flutter build apk \
  --dart-define=FLAVOR=prod \
  --release \
  --split-per-abi

echo "✅ Build complete!"
echo ""
echo "📦 Output files:"
ls -lh build/app/outputs/flutter-apk/app-*-release.apk

echo ""
echo "📱 Recommended for upload (arm64 - 95% devices):"
ls -lh build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
