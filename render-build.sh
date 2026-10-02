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
# --no-web-resources-cdn: CanvasKit is served from this site, not from
# Google's CDN (www.gstatic.com), so visitors' browsers never contact Google.
flutter build web --release \
  --no-web-resources-cdn \
  --pwa-strategy=offline-first \
  --dart-define=APP_ENV="${APP_ENV:-production}"
./patch-service-worker.sh
