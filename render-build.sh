#!/usr/bin/env bash
# Render static-site build: installs the pinned Flutter SDK (cached between
# builds when Render keeps the cache directory), then builds the web bundle
# into build/web.
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.24.2}"
FLUTTER_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/flutter-${FLUTTER_VERSION}"

if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  echo "Installing Flutter ${FLUTTER_VERSION}…"
  rm -rf "${FLUTTER_DIR}"
  git clone --depth 1 --branch "${FLUTTER_VERSION}" \
    https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
fi
export PATH="${FLUTTER_DIR}/bin:${PATH}"

flutter config --no-analytics --enable-web > /dev/null
flutter --version
flutter pub get

# --pwa-strategy=offline-first: a service worker keeps the site on the
# visitor's device, so repeat visits open almost instantly, even on a poor
# connection. After a deploy, returning visitors get the new version on
# their next visit (flutter_service_worker.js is served with no-cache).
# --web-renderer=html: this site is Frankfurt-hosted but most visitors are
# on African mobile networks, often 3G/4G. CanvasKit adds a 3-6 MB WASM
# download on first visit (canvaskit.wasm + its Chromium variant); the HTML
# renderer skips it entirely. The app uses no CanvasKit-only features
# (no shaders, no BackdropFilter), so visuals are unaffected.
flutter build web --release \
  --web-renderer=html \
  --pwa-strategy=offline-first \
  --dart-define=APP_ENV="${APP_ENV:-production}"
./patch-service-worker.sh
