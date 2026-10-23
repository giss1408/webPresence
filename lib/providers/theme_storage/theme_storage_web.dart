import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Same key as web/pages.js: 'light' or 'dark'.
const _key = 'theme';

JSObject? get _storage {
  try {
    return globalContext.getProperty<JSObject?>('localStorage'.toJS);
  } catch (_) {
    return null; // blocked storage (private mode, site data off)
  }
}

String? readSavedTheme() {
  try {
    final value = _storage
        ?.callMethod<JSString?>('getItem'.toJS, _key.toJS)
        ?.toDart;
    return value == 'dark' || value == 'light' ? value : null;
  } catch (_) {
    return null;
  }
}

void saveTheme(String theme) {
  try {
    _storage?.callMethod<JSAny?>('setItem'.toJS, _key.toJS, theme.toJS);
  } catch (_) {
    // Not remembered; the choice still applies for this visit.
  }
}

bool systemPrefersDark() {
  try {
    final query = globalContext.callMethod<JSObject>(
        'matchMedia'.toJS, '(prefers-color-scheme: dark)'.toJS);
    return query.getProperty<JSBoolean>('matches'.toJS).toDart;
  } catch (_) {
    return false;
  }
}
