import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url]. On the web, [sameTab] replaces the site in the current tab
/// (for the static pages served next to the app, e.g. the blog); otherwise
/// it opens in a new tab.
///
/// A site path like '/blog/' is resolved against the current page: the web
/// launcher only accepts URLs with an http(s) scheme.
///
/// Always passes an explicit `_self`/`_blank` window name: leaving it null
/// makes url_launcher_web call `window.open(url, '')`, and some browsers
/// treat that empty target as the *current* tab instead of a new one.
Future<bool> openUrl(String url,
    {bool newWindow = false, bool sameTab = false}) async {
  final uri = Uri.base.resolve(url);
  try {
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        webOnlyWindowName: sameTab ? '_self' : '_blank',
      );
    } else {
      debugPrint("Could not launch $url");
      return false;
    }
  } catch (e) {
    debugPrint("Could not launch $url");
    return false;
  }
}
