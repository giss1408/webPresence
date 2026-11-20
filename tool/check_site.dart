// Site checks for the static Regisse website.
// Usage: dart run tool/check_site.dart   (exit 0 = all pass, 1 = failures)
import 'dart:convert';
import 'dart:io';

final failures = <String>[];
void fail(String rule, String where) => failures.add('FAIL $rule: $where');

const legalDirs = {'mentions-legales', 'confidentialite', 'conditions'};

List<File> htmlFiles() => Directory('web')
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.html'))
    .toList();

String rel(File f) => f.path;

void checkNoInlineScript(List<File> files) {
  final inline = RegExp(r'<script(?![^>]*\bsrc=)[^>]*>(?![^<]*</script>\s*$)([\s\S]*?)</script>',
      caseSensitive: false);
  for (final f in files) {
    for (final m in inline.allMatches(f.readAsStringSync())) {
      final tag = m.group(0)!;
      // JSON-LD data blocks are not executable scripts.
      if (RegExp(r'type="application/ld\+json"').hasMatch(tag)) continue;
      fail('no-inline-script', rel(f));
      break;
    }
  }
}

void checkNoDueDiligence(List<File> files) {
  final targets = <File>[
    ...files,
    File('web/sitemap.xml'),
    ...Directory('blog-posts')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.md')),
  ];
  final re = RegExp('due[\\s-]+diligence', caseSensitive: false);
  for (final f in targets) {
    if (f.existsSync() && re.hasMatch(f.readAsStringSync())) {
      fail('no-due-diligence', rel(f));
    }
  }
}

void checkNoGerman(List<File> files) {
  for (final f in files) {
    final s = f.readAsStringSync();
    if (s.contains('hreflang="de"') || RegExp(r'lang="de').hasMatch(s)) {
      fail('no-german', rel(f));
    }
  }
}

bool targetExists(String path) {
  final clean = path.split('#').first.split('?').first;
  if (clean.isEmpty) return true;
  final p = 'web$clean';
  if (clean.endsWith('/')) return File('${p}index.html').existsSync();
  return File(p).existsSync() || File('$p/index.html').existsSync();
}

void checkLinks(List<File> files) {
  final re = RegExp(r'''(?:href|src)="(/[^"/][^"]*|/)"''');
  for (final f in files) {
    for (final m in re.allMatches(f.readAsStringSync())) {
      final link = m.group(1)!;
      if (!targetExists(link)) fail('links-resolve', '${rel(f)} -> $link');
    }
  }
}

void checkSitemap(List<File> files) {
  final sm = File('web/sitemap.xml');
  if (!sm.existsSync()) {
    fail('sitemap-matches', 'web/sitemap.xml missing');
    return;
  }
  final listed = RegExp(r'<loc>([^<]+)</loc>')
      .allMatches(sm.readAsStringSync())
      .map((m) => Uri.parse(m.group(1)!).path)
      .toSet();
  for (final p in listed) {
    if (!targetExists(p)) fail('sitemap-matches', 'listed but missing: $p');
  }
  for (final f in files) {
    final path = f.path.substring('web'.length);
    if (!path.endsWith('/index.html')) continue;
    final url = path.substring(0, path.length - 'index.html'.length);
    final top = url.split('/').where((s) => s.isNotEmpty).toList();
    if (top.isNotEmpty && legalDirs.contains(top.first)) continue;
    if (!listed.contains(url)) fail('sitemap-matches', 'not listed: $url');
  }
}

void checkHtmlWeight() {
  for (final p in ['web/index.html', 'web/en/index.html']) {
    final f = File(p);
    if (!f.existsSync()) {
      fail('html-weight', '$p missing');
    } else if (f.lengthSync() > 150000) {
      fail('html-weight', '$p is ${f.lengthSync()} bytes (max 150000)');
    }
  }
}

void checkProductFields() {
  final f = File('data/products.json');
  if (!f.existsSync()) {
    fail('product-fields', 'data/products.json missing');
    return;
  }
  final list = jsonDecode(f.readAsStringSync()) as List;
  const langs = ['fr', 'en'];
  const bilingual = ['outcome', 'problem'];
  for (final raw in list) {
    final p = raw as Map<String, dynamic>;
    final slug = p['slug'] as String? ?? '?';
    for (final k in ['slug', 'name', 'accent']) {
      if ((p[k] as String?)?.isNotEmpty != true) {
        fail('product-fields', '$slug.$k missing');
      }
    }
    for (final k in bilingual) {
      for (final l in langs) {
        if (((p[k] as Map?)?[l] as String?)?.isNotEmpty != true) {
          fail('product-fields', '$slug.$k.$l missing');
        }
      }
    }
    for (final l in langs) {
      final items = ((p['features'] as Map?)?[l] as List?) ?? const [];
      if (items.length < 3 || items.length > 6) {
        fail('product-fields', '$slug.features.$l needs 3 to 6 items');
      }
    }
  }
  const expected = {
    'fidelia', 'supermarche', 'akwaba-ivoire', 'immoizi', 'cabosse', 'petitgombo'
  };
  final slugs = list.map((e) => (e as Map)['slug']).toSet();
  if (!slugs.containsAll(expected)) {
    fail('product-fields', 'missing slugs: ${expected.difference(slugs)}');
  }
}

void checkHomeStructure() {
  for (final p in ['web/index.html', 'web/en/index.html']) {
    final f = File(p);
    if (!f.existsSync()) continue; // reported by html-weight
    final s = f.readAsStringSync();
    for (final id in ['hero', 'produits', 'methode', 'preuves', 'securite', 'contact']) {
      if (!s.contains('id="$id"')) fail('home-structure', '$p missing #$id');
    }
    if (RegExp(r'<h1[ >]').allMatches(s).length != 1) {
      fail('home-structure', '$p needs exactly one h1');
    }
    for (final needle in ['rel="canonical"', 'hreflang="fr"', 'hreflang="en"']) {
      if (!s.contains(needle)) fail('home-structure', '$p missing $needle');
    }
  }
}

/// `.reveal` content must only be hidden when JS runs (selector under `.js`).
void checkJsGuard() {
  final css = File('web/site.css').readAsStringSync();
  final rule = RegExp(r'([^{}]+)\{([^{}]*)\}');
  for (final m in rule.allMatches(css)) {
    final sel = m.group(1)!.trim();
    if (sel.contains('.reveal') &&
        RegExp(r'opacity:\s*0\s*[;}]?').hasMatch(m.group(2)!) &&
        !sel.contains('.js ')) {
      fail('js-guard', 'site.css: "$sel" hides content without .js guard');
    }
  }
}

void checkSharedShell(List<File> files) {
  for (final f in files) {
    final s = f.readAsStringSync();
    if (s.contains('pages.css') || s.contains('pages.js')) {
      fail('shared-shell', '${rel(f)} still uses pages.css/pages.js');
    }
    if (!RegExp(r'href="(/en)?/#produits"').hasMatch(s)) {
      fail('shared-shell', '${rel(f)} lacks the shared header');
    }
  }
}

void main() {
  final files = htmlFiles();
  checkNoInlineScript(files);
  checkNoDueDiligence(files);
  checkNoGerman(files);
  checkLinks(files);
  checkSitemap(files);
  checkHtmlWeight();
  checkProductFields();
  checkHomeStructure();
  checkJsGuard();
  checkSharedShell(files);
  if (failures.isEmpty) {
    print('All site checks passed (${files.length} html files).');
  } else {
    failures.forEach(print);
    print('${failures.length} failure(s).');
    exit(1);
  }
}
