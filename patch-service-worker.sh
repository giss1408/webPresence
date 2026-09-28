#!/usr/bin/env bash
# Run after `flutter build web --pwa-strategy=offline-first`.
#
# Flutter's service worker installs with {'cache': 'reload'}, which ignores
# the browser cache: a first visit then downloads main.dart.js twice. With
# 'no-cache' it revalidates instead (a small 304 when nothing changed).
set -euo pipefail

sw="${1:-build/web/flutter_service_worker.js}"
from="{'cache': 'reload'}"
to="{'cache': 'no-cache'}"

if ! grep -qF "$from" "$sw"; then
  echo "patch-service-worker.sh: \"$from\" not found in $sw;" \
    "Flutter's service worker changed, update this script." >&2
  exit 1
fi
sed -i.bak "s/$from/$to/" "$sw"
rm "$sw.bak"
echo "patch-service-worker.sh: install now revalidates instead of reloading."
