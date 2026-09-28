{{flutter_js}}
{{flutter_build_config}}

// Start the app right away. Flutter's default first waits (up to 4 s) for
// the service worker, and on slow networks both then download main.dart.js.
_flutter.loader.load();

// Install the offline cache once the site is on screen, so it never
// competes with the first load. On later visits it serves the site from the
// device; after a deploy the new version is cached for the next visit.
window.addEventListener('flutter-first-frame', function () {
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register(
      'flutter_service_worker.js?v=' + {{flutter_service_worker_version}});
  }
});
