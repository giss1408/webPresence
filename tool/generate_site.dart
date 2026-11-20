// Renders product cards, product pages, shared header/footer and the
// marquee into the static site, then runs the blog generator.
// Usage: dart run tool/generate_site.dart   (idempotent)
import 'dart:convert';
import 'dart:io';

const domain = 'https://mobile-technologies.milikey-energy.com';
const waNumber = '4917634620220';
const email = 'info@milikey-energy.com';

String esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

class Product {
  Product(this.json);
  final Map<String, dynamic> json;
  String get slug => json['slug'] as String;
  String get name => json['name'] as String;
  String get accent => json['accent'] as String;
  String outcome(String l) => (json['outcome'] as Map)[l] as String;
  String problem(String l) => (json['problem'] as Map)[l] as String;
  List<Map<String, dynamic>> get screens =>
      List<Map<String, dynamic>>.from((json['screens'] as List?) ?? const []);
  List<String> features(String l) =>
      List<String>.from((json['features'] as Map)[l] as List);
}

List<Product> loadProducts() {
  final list = jsonDecode(File('data/products.json').readAsStringSync()) as List;
  final out = <Product>[];
  var bad = false;
  for (final raw in list) {
    final p = Product(raw as Map<String, dynamic>);
    for (final k in ['name', 'accent', 'slug']) {
      if ((p.json[k] as String?)?.isNotEmpty != true) {
        stderr.writeln('products.json: ${p.json['slug']}.$k missing');
        bad = true;
      }
    }
    for (final k in ['outcome', 'problem']) {
      for (final l in ['fr', 'en']) {
        if (((p.json[k] as Map?)?[l] as String?)?.isNotEmpty != true) {
          stderr.writeln('products.json: ${p.json['slug']}.$k.$l missing');
          bad = true;
        }
      }
    }
    for (final l in ['fr', 'en']) {
      if ((((p.json['features'] as Map?)?[l]) as List?)?.isNotEmpty != true) {
        stderr.writeln('products.json: ${p.json['slug']}.features.$l missing');
        bad = true;
      }
    }
    out.add(p);
  }
  if (bad) exit(1);
  return out;
}

String productPath(String lang, String slug) =>
    lang == 'fr' ? '/produits/$slug/' : '/en/products/$slug/';

const brandSvg =
    '<svg viewBox="0 0 40 40" aria-hidden="true"><rect width="40" height="40" rx="10" fill="#0B5FD0"/><path d="M10 29V11l10 11 10-11v18" fill="none" stroke="#fff" stroke-width="3.8" stroke-linecap="round" stroke-linejoin="round"/><rect x="15" y="32" width="10" height="3.2" rx="1.6" fill="#FFB020"/></svg>';

String header(String lang, {String? otherLangHref}) {
  final fr = lang == 'fr';
  final home = fr ? '/' : '/en/';
  final other = otherLangHref ?? (fr ? '/en/' : '/');
  return '''  <header class="bar">
    <div class="wrap wide">
      <a class="brand" href="$home">
        $brandSvg
        milikey Digital
      </a>
      <nav>
        <a href="${home}#produits">${fr ? 'Produits' : 'Products'}</a>
        <a href="${home}#methode">${fr ? 'Méthode' : 'Method'}</a>
        <a href="/securite/">${fr ? 'Sécurité' : 'Security (FR)'}</a>
        <a href="/blog/">Blog${fr ? '' : ' (FR)'}</a>
        <a class="lang" href="$other" hreflang="${fr ? 'en' : 'fr'}" lang="${fr ? 'en' : 'fr'}">${fr ? 'EN' : 'FR'}</a>
      </nav>
      <button class="theme-toggle" type="button" aria-label="${fr ? 'Changer de thème' : 'Change theme'}">🌙</button>
    </div>
  </header>''';
}

String footer(String lang) {
  final fr = lang == 'fr';
  final home = fr ? '/' : '/en/';
  return '''  <footer>
    <div class="wrap wide">
      <span>© milikey Digital</span>
      <a href="$home">${fr ? 'Accueil' : 'Home'}</a>
      <a href="/developpement-saas-mobile/">${fr ? 'Développement sur mesure' : 'Custom development (FR)'}</a>
      <a href="/blog/">Blog</a>
      <a href="/conditions/">${fr ? 'Conditions' : 'Terms (FR)'}</a>
      <a href="/confidentialite/">${fr ? 'Confidentialité' : 'Privacy (FR)'}</a>
      <a href="/securite/">${fr ? 'Sécurité' : 'Security (FR)'}</a>
      <a href="/mentions-legales/">${fr ? 'Mentions légales' : 'Legal notice (FR)'}</a>
    </div>
  </footer>''';
}

String cards(List<Product> ps, String lang) {
  final fr = lang == 'fr';
  var i = 0;
  return ps.map((p) {
    final d = (i++ % 3) + 1;
    return '''          <a class="product reveal" data-delay="$d" style="--c:${esc(p.accent)}" href="${productPath(lang, p.slug)}">
            <span class="tag">${fr ? 'Disponible' : 'Available'}</span>
            <h3>${esc(p.name)}</h3>
            <p>${esc(p.outcome(lang))}</p>
            <span class="more">${fr ? 'Voir le produit' : 'View product'} →</span>
          </a>''';
  }).join('\n');
}

String marquee(List<Product> ps) {
  final spans = ps.map((p) => '<span>${esc(p.name)}</span>').join();
  return '''    <div class="marquee" aria-hidden="true">
      <div class="marquee-track">$spans$spans</div>
    </div>''';
}

/// Replaces everything between `<!-- name:start -->` and `<!-- name:end -->`.
String inject(String src, String name, String content, String file) {
  final re = RegExp('([ \\t]*)<!-- $name:start -->[\\s\\S]*?<!-- $name:end -->');
  if (!re.hasMatch(src)) {
    stderr.writeln('$file: markers for "$name" not found');
    exit(1);
  }
  final m = re.firstMatch(src)!;
  final indent = m.group(1)!;
  return src.replaceFirst(
      re, '$indent<!-- $name:start -->\n$content\n$indent<!-- $name:end -->');
}

String waLink(String text) =>
    'https://wa.me/$waNumber?text=${Uri.encodeComponent(text)}';

String screensSection(Product p, String lang) {
  if (p.screens.isEmpty) return '';
  final fr = lang == 'fr';
  final figs = p.screens.map((s) {
    final alt = esc((s['alt'] as Map)[lang] as String);
    return '          <figure class="shot reveal"><img src="${esc(s['src'] as String)}" alt="$alt" width="225" height="487" loading="lazy"><figcaption>$alt</figcaption></figure>';
  }).join('\n');
  return '''    <section class="shots-section">
      <div class="wrap wide">
        <h2 class="reveal">${fr ? 'Aperçu' : 'Preview'}</h2>
        <div class="shots">
$figs
        </div>
      </div>
    </section>
''';
}

String productPage(Product p, String lang) {
  final fr = lang == 'fr';
  final path = productPath(lang, p.slug);
  final otherPath = productPath(fr ? 'en' : 'fr', p.slug);
  final title =
      '${p.name} — ${fr ? 'solution prête à l\'emploi' : 'ready-to-go solution'} | milikey Digital';
  final desc = p.outcome(lang);
  final wa = waLink(fr
      ? 'Bonjour, je suis intéressé(e) par ${p.name}.'
      : 'Hello, I am interested in ${p.name}.');
  final steps = fr
      ? ['Choisir', 'Adapter', 'Lancer', 'Accompagner']
      : ['Choose', 'Adapt', 'Launch', 'Support'];
  final stepText = fr
      ? [
          'Vous confirmez que ce produit correspond à votre besoin.',
          'Marque, contenus, règles métier et langues à votre image.',
          'Publication et mise en ligne en quelques semaines.',
          'Suivi, corrections et évolutions après le lancement.'
        ]
      : [
          'You confirm this product fits your need.',
          'Brand, content, business rules and languages made yours.',
          'Publication and go-live in weeks.',
          'Follow-up, fixes and improvements after launch.'
        ];
  final home = fr ? '/' : '/en/';
  return '''<!DOCTYPE html>
<html lang="$lang">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${esc(title)}</title>
  <meta name="description" content="${esc(desc)}">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="$domain$path">
  <link rel="alternate" hreflang="${fr ? 'fr' : 'en'}" href="$domain$path">
  <link rel="alternate" hreflang="${fr ? 'en' : 'fr'}" href="$domain$otherPath">
  <meta name="theme-color" content="#0B5FD0">
  <meta property="og:type" content="website">
  <meta property="og:url" content="$domain$path">
  <meta property="og:title" content="${esc(title)}">
  <meta property="og:description" content="${esc(desc)}">
  <meta property="og:image" content="$domain/icons/Icon-512.png">
  <link rel="icon" type="image/svg+xml" href="/favicon.svg?v=2">
  <link rel="stylesheet" href="/site.css">
  <script src="/site.js"></script>
</head>
<body>
${header(lang, otherLangHref: otherPath)}

  <main class="product-page" style="--c:${esc(p.accent)}">
    <section class="hero">
      <div class="wrap">
        <p class="crumbs"><a href="$home">${fr ? 'Accueil' : 'Home'}</a> / <a href="${home}#produits">${fr ? 'Produits' : 'Products'}</a></p>
        <span class="tag">${fr ? 'Disponible' : 'Available'}</span>
        <h1>${esc(p.name)}</h1>
        <p class="lead">${esc(p.outcome(lang))}</p>
        <div class="actions">
          <a class="btn" href="$wa">${fr ? 'Demander ce produit' : 'Ask about this product'}</a>
          <a class="btn ghost" href="${home}#produits">${fr ? 'Tous les produits' : 'All products'}</a>
        </div>
      </div>
    </section>
${screensSection(p, lang)}    <section>
      <div class="wrap">
        <h2 class="reveal">${fr ? 'Le problème résolu' : 'The problem it solves'}</h2>
        <p class="reveal">${esc(p.problem(lang))}</p>
        <h2 class="reveal">${fr ? 'Ce que contient le produit' : 'What is included'}</h2>
        <ul class="checks reveal">
${p.features(lang).map((f) => '          <li>${esc(f)}</li>').join('\n')}
        </ul>
        <h2 class="reveal">${fr ? 'Comment nous l\'adaptons à vous' : 'How we adapt it to you'}</h2>
        <ol class="timeline reveal">
${List.generate(4, (i) => '          <li><strong>${steps[i]}</strong><span>${stepText[i]}</span></li>').join('\n')}
        </ol>
        <div class="actions reveal">
          <a class="btn" href="$wa">WhatsApp</a>
          <a class="btn ghost" href="mailto:$email?subject=${Uri.encodeComponent(p.name)}">$email</a>
        </div>
      </div>
    </section>
  </main>

${footer(lang)}
</body>
</html>
''';
}

void writeFile(String path, String content) {
  final f = File(path);
  f.parent.createSync(recursive: true);
  if (!f.existsSync() || f.readAsStringSync() != content) {
    f.writeAsStringSync(content);
  }
}

/// Fills the shared header/footer in every page that carries the markers.
void injectShell() {
  for (final f in Directory('web').listSync(recursive: true).whereType<File>()) {
    if (!f.path.endsWith('.html')) continue;
    final s = f.readAsStringSync();
    if (!s.contains('<!-- header:start -->')) continue;
    final lang = f.path.startsWith('web/en/') ? 'en' : 'fr';
    var out = inject(s, 'header', header(lang), f.path);
    out = inject(out, 'footer', footer(lang), f.path);
    writeFile(f.path, out);
  }
}

Future<void> main() async {
  final ps = loadProducts();
  for (final lang in ['fr', 'en']) {
    final file = lang == 'fr' ? 'web/index.html' : 'web/en/index.html';
    var s = File(file).readAsStringSync();
    s = inject(s, 'marquee', marquee(ps), file);
    s = inject(s, 'products', cards(ps, lang), file);
    writeFile(file, s);
    for (final p in ps) {
      writeFile('web${productPath(lang, p.slug)}index.html', productPage(p, lang));
    }
  }
  // Sitemap block for home (EN) and product pages.
  const sm = 'web/sitemap.xml';
  final urls = [
    '/en/',
    for (final l in ['fr', 'en']) for (final p in ps) productPath(l, p.slug),
  ];
  final block = urls.map((u) => '  <url><loc>$domain$u</loc></url>').join('\n');
  writeFile(sm, inject(File(sm).readAsStringSync(), 'products', block, sm));

  final r = await Process.run('dart', ['run', 'tool/generate_blog.dart']);
  stdout.write(r.stdout);
  stderr.write(r.stderr);
  if (r.exitCode != 0) exit(r.exitCode);
  injectShell();
  print('Site generated: ${ps.length} products.');
}
