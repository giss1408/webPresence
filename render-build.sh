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

# --pwa-strategy=none: no offline service worker, so visitors always get the
# latest deploy instead of a cached copy of the previous one.
flutter build web --release \
  --pwa-strategy=none \
  --dart-define=APP_ENV="${APP_ENV:-production}"
