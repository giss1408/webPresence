// Where the visitor's light/dark choice lives. On the web it is the same
// `localStorage` key the blog and the other static pages use
// (web/pages.js), so the choice follows the visitor between them.
export 'theme_storage_stub.dart'
    if (dart.library.js_interop) 'theme_storage_web.dart';
