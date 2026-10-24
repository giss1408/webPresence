// ignore_for_file: avoid_print
// Generates the blog's static pages from Markdown sources.
//
// Reads every blog-posts/*.md (front matter + Markdown body), renders each
// into web/blog/<slug>/index.html using the site's existing page template,
// rebuilds web/blog/index.html (newest first, grouped by year) and the
// blog entries in web/sitemap.xml.
//
// Run with: dart run tool/generate_blog.dart
//
// To publish a new post: add blog-posts/<slug>.md with the front matter
// shown below, run this script, then commit and push — Render auto-deploys.
//
// ---
// title: Post title
// description: <meta name="description"> and the JSON-LD headline source.
// ogDescription: Shorter description for social previews.
// excerpt: Shown on the blog index under the title.
// date: 2026-10-02
// readingMinutes: 7
// whatsappText: Pre-filled WhatsApp message for the post's CTA button.
// secondaryLinkHref: /blog/            (optional, defaults to /blog/)
// secondaryLinkLabel: Tous les articles (optional)
// ---
// Markdown body here. Raw HTML blocks (e.g. <div class="offer">...</div>)
// pass through untouched, for the few posts with a custom block.

import 'dart:io';
import 'package:markdown/markdown.dart' as md;

const _siteUrl = 'https://mobile-technologies.milikey-energy.com';
const _company = 'Regisse - Mobile Business Technologies';
const _author = 'RMBT-Team';
const _whatsappNumber = '4917634620220';
const _email = 'mobile-business@regisse.com';

const _monthsFr = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

class Post {
  final String slug;
  final String title;
  final String description;
  final String ogDescription;
  final String excerpt;
  final DateTime date;
  final int readingMinutes;
  final String whatsappText;
  final String secondaryLinkHref;
  final String secondaryLinkLabel;
  final String bodyHtml;
  final List<({String id, String text})> toc;

  Post({
    required this.slug,
    required this.title,
    required this.description,
    required this.ogDescription,
    required this.excerpt,
    required this.date,
    required this.readingMinutes,
    required this.whatsappText,
    required this.secondaryLinkHref,
    required this.secondaryLinkLabel,
    required this.bodyHtml,
    required this.toc,
  });

  String get dateIso =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String get dateFr => '${date.day} ${_monthsFr[date.month - 1]} ${date.year}';
}

String _slugify(String fileName) =>
    fileName.replaceAll(RegExp(r'\.md$'), '');

/// The `markdown` package's BlockSyntax.generateAnchorHash, reproduced
/// exactly so the table of contents links land on the right heading:
/// lowercase, strip everything but [a-z0-9 _-] (accents are dropped, not
/// transliterated), then spaces to dashes.
String _anchorHash(String text) => text
    .toLowerCase()
    .trim()
    .replaceAll(RegExp('[^a-z0-9 _-]'), '')
    .replaceAll(RegExp(r'\s'), '-');

/// Pulls out each top-level (##) heading's text and its generated id.
List<({String id, String text})> _extractToc(String bodyMarkdown) {
  final toc = <({String id, String text})>[];
  for (final line in bodyMarkdown.split('\n')) {
    final match = RegExp(r'^##\s+(.+)$').firstMatch(line);
    if (match == null) continue;
    final text = match.group(1)!.trim();
    toc.add((id: _anchorHash(text), text: text));
  }
  return toc;
}

/// Parses `key: value` front matter lines. Deliberately not YAML: post
/// text is French prose full of colons ("Mobile Money : ..."), which a
/// strict YAML parser rejects unless every value is quoted. Only the first
/// colon on each line is treated as the separator.
Map<String, String> _parseFrontMatter(String block) {
  final result = <String, String>{};
  for (final line in block.split('\n')) {
    if (line.trim().isEmpty) continue;
    final i = line.indexOf(':');
    if (i == -1) {
      throw FormatException('Front matter line has no ":": "$line"');
    }
    result[line.substring(0, i).trim()] = line.substring(i + 1).trim();
  }
  return result;
}

Post _parsePost(File file) {
  final raw = file.readAsStringSync();
  final match =
      RegExp(r'^---\n(.*?)\n---\n(.*)$', dotAll: true).firstMatch(raw);
  if (match == null) {
    throw FormatException('${file.path}: missing --- front matter block');
  }
  final front = _parseFrontMatter(match.group(1)!);
  final bodyMarkdown = match.group(2)!.trim();

  final slug = _slugify(file.uri.pathSegments.last);
  final title = front['title']!;
  final description = front['description']!;
  final date = DateTime.parse(front['date']!);

  final bodyHtml = md.markdownToHtml(
    bodyMarkdown,
    extensionSet: md.ExtensionSet.gitHubWeb,
    inlineSyntaxes: [md.InlineHtmlSyntax()],
  );

  return Post(
    slug: slug,
    title: title,
    description: description,
    ogDescription: front['ogDescription'] ?? description,
    excerpt: front['excerpt'] ?? description,
    date: date,
    readingMinutes: int.tryParse(front['readingMinutes'] ?? '') ?? 5,
    whatsappText:
        front['whatsappText'] ?? 'Bonjour, j\'aimerais discuter de mon projet.',
    secondaryLinkHref: front['secondaryLinkHref'] ?? '/blog/',
    secondaryLinkLabel: front['secondaryLinkLabel'] ?? 'Tous les articles',
    bodyHtml: bodyHtml,
    toc: _extractToc(bodyMarkdown),
  );
}

String _escapeAttr(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

String _waUrl(String text) =>
    'https://wa.me/$_whatsappNumber?text=${Uri.encodeComponent(text)}';

String _mailUrl(String text) =>
    'mailto:$_email?subject=${Uri.encodeComponent('Demande de projet — Regisse')}'
    '&body=${Uri.encodeComponent(text)}';

const _navHtml = '''
  <header class="bar">
    <div class="wrap">
      <a class="brand" href="/">
        <svg viewBox="0 0 40 40" aria-hidden="true"><rect width="40" height="40" rx="10" fill="#0B5FD0"/><path d="M10.5 29V11h7.25a5.25 5.25 0 0 1 0 10.5H10.5M16.75 21.5 22.5 29" fill="none" stroke="#fff" stroke-width="3.8" stroke-linecap="round" stroke-linejoin="round"/><rect x="25.25" y="27.1" width="6.5" height="3.8" rx="1.9" fill="#FFB020"/></svg>
        Mobile Business Technologies
      </a>
      <nav>
        <a href="/">Accueil</a>
        <a href="/developpement-saas-mobile/">SaaS mobile</a>
        <a href="/due-diligence-technique/">Investisseurs</a>
        <a href="/blog/" aria-current="page">Blog</a>
      </nav>
      <button class="theme-toggle" type="button" aria-label="Changer de thème">🌙</button>
    </div>
  </header>''';

const _footerHtml = '''
  <footer>
    <div class="wrap">
      <span>© $_company</span>
      <a href="/">Accueil</a>
      <a href="/developpement-saas-mobile/">Développement SaaS mobile</a>
      <a href="/due-diligence-technique/">Due diligence technique</a>
      <a href="/blog/">Blog</a>
      <a href="/conditions/">Conditions</a>
      <a href="/confidentialite/">Confidentialité</a>
      <a href="/securite/">Sécurité</a>
      <a href="/mentions-legales/">Mentions légales</a>
    </div>
  </footer>''';

String _renderPostPage(Post p) {
  final url = '$_siteUrl/blog/${p.slug}/';
  final toc = p.toc.isEmpty
      ? ''
      : '''
        <nav class="toc" aria-label="Sommaire">
          <p>Dans cet article</p>
          <ol>
            ${p.toc.map((e) => '<li><a href="#${e.id}">${e.text}</a></li>').join('\n            ')}
          </ol>
        </nav>''';
  // Without headings there is nothing to put in the sidebar column, so the
  // body simply takes the full width instead of leaving an empty gap.
  final layoutOpen = p.toc.isEmpty
      ? ''
      : '<div class="post-layout">$toc\n        <div>';
  final layoutClose = p.toc.isEmpty ? '' : '</div>\n      </div>';

  return '''<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${p.title} | $_company</title>
  <meta name="description" content="${_escapeAttr(p.description)}">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="$url">
  <meta name="theme-color" content="#0B5FD0">
  <meta property="og:type" content="article">
  <meta property="og:locale" content="fr_FR">
  <meta property="og:url" content="$url">
  <meta property="og:title" content="${_escapeAttr(p.title)}">
  <meta property="og:description" content="${_escapeAttr(p.ogDescription)}">
  <meta property="og:image" content="$_siteUrl/icons/Icon-512.png">
  <link rel="icon" type="image/svg+xml" href="/favicon.svg?v=2">
  <link rel="stylesheet" href="/pages.css">
  <script src="/pages.js" defer></script>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    "headline": "${_escapeAttr(p.title)}",
    "datePublished": "${p.dateIso}",
    "dateModified": "${p.dateIso}",
    "inLanguage": "fr",
    "author": { "@type": "Organization", "name": "$_author" },
    "publisher": { "@type": "Organization", "name": "$_company", "logo": { "@type": "ImageObject", "url": "$_siteUrl/icons/Icon-512.png" } },
    "mainEntityOfPage": "$url",
    "image": "$_siteUrl/icons/Icon-512.png"
  }
  </script>
</head>
<body>
$_navHtml

  <main class="wrap post-article">
    <article>
      <p class="meta"><a href="/blog/">← Blog</a> · <time datetime="${p.dateIso}">${p.dateFr}</time> · ${p.readingMinutes} min de lecture · $_author</p>
      <h1>${p.title}</h1>
      $layoutOpen
${p.bodyHtml}
      $layoutClose

      <div class="actions">
        <a class="btn" href="${_waUrl(p.whatsappText)}">Parler de mon projet par WhatsApp</a>
        <a class="btn" href="${_mailUrl(p.whatsappText)}">Parler de mon projet par e-mail</a>
        <a class="btn ghost" href="${p.secondaryLinkHref}">${p.secondaryLinkLabel}</a>
      </div>
    </article>
  </main>

$_footerHtml
</body>
</html>
''';
}

String _renderIndexPage(List<Post> posts) {
  final byYear = <int, List<Post>>{};
  for (final p in posts) {
    byYear.putIfAbsent(p.date.year, () => []).add(p);
  }
  final years = byYear.keys.toList()..sort((a, b) => b.compareTo(a));

  final sections = years.map((year) {
    final items = byYear[year]!.map((p) => '''
      <li>
        <p class="meta"><time datetime="${p.dateIso}">${p.dateFr}</time> · ${p.readingMinutes} min de lecture · $_author</p>
        <h2 id="${p.slug}"><a href="/blog/${p.slug}/">${p.title}</a></h2>
        <p>${p.excerpt}</p>
      </li>''').join('\n');
    return '<p class="archive-year">$year</p>\n    <ul class="posts">$items\n    </ul>';
  }).join('\n    ');

  // Quick-jump sidebar: every post's title, linking to its own section
  // further down this same page (not to headings within one article —
  // the per-article table of contents is a separate thing on each post
  // page). Same sidebar classes as the post pages for a consistent look.
  final toc = '''
        <nav class="toc" aria-label="Tous les articles">
          <p>Tous les articles</p>
          <ol>
            ${posts.map((p) => '<li><a href="#${p.slug}">${p.title}</a></li>').join('\n            ')}
          </ol>
        </nav>''';

  return '''<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Blog — SaaS mobile, applications et Mobile Money en Afrique | $_company</title>
  <meta name="description" content="Conseils pour lancer un SaaS mobile en Afrique de l'Ouest : coût d'une application, MVP, Mobile Money, mode hors-ligne, iOS et Android.">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="$_siteUrl/blog/">
  <meta name="theme-color" content="#0B5FD0">
  <meta property="og:type" content="website">
  <meta property="og:locale" content="fr_FR">
  <meta property="og:url" content="$_siteUrl/blog/">
  <meta property="og:title" content="Blog $_company — SaaS mobile en Afrique">
  <meta property="og:image" content="$_siteUrl/icons/Icon-512.png">
  <link rel="icon" type="image/svg+xml" href="/favicon.svg?v=2">
  <link rel="stylesheet" href="/pages.css">
  <script src="/pages.js" defer></script>
</head>
<body>
$_navHtml

  <main class="wrap post-article">
    <span class="badge">Blog</span>
    <h1>Lancer un SaaS mobile en Afrique</h1>
    <p class="lead">Coûts, méthode, Mobile Money, mode hors-ligne : nos conseils pour passer de l'idée à une application que vos clients utilisent vraiment.</p>

    <div class="post-layout">
$toc
      <div>
    <!-- Generated by tool/generate_blog.dart from blog-posts/*.md — do not
         edit by hand, run the script instead. -->
    $sections
      </div>
    </div>
  </main>

$_footerHtml
</body>
</html>
''';
}

const _sitemapMarker =
    '<!-- Blog posts: generated by tool/generate_blog.dart from blog-posts/*.md. -->';

void _updateSitemap(List<Post> posts) {
  final file = File('web/sitemap.xml');
  final lines = file.readAsStringSync().split('\n');

  // Drop every existing /blog/ <url> line and the old marker comment, keep
  // every other line (static pages) exactly where it was, then insert the
  // freshly generated blog entries right before </urlset>.
  final kept = lines
      .where((l) => !l.contains('<loc>$_siteUrl/blog/'))
      .where((l) => l.trim() != _sitemapMarker)
      .where((l) => l.trim() != '<!-- Add each new blog post here (and to /blog/index.html). -->')
      .toList();

  final today = posts
      .map((p) => p.dateIso)
      .fold<String>('', (max, d) => d.compareTo(max) > 0 ? d : max);
  final blogUrls = [
    _sitemapMarker,
    '  <url><loc>$_siteUrl/blog/</loc><lastmod>$today</lastmod></url>',
    for (final p in posts)
      '  <url><loc>$_siteUrl/blog/${p.slug}/</loc><lastmod>${p.dateIso}</lastmod></url>',
  ];

  final urlsetCloseIndex = kept.indexWhere((l) => l.contains('</urlset>'));
  if (urlsetCloseIndex == -1) {
    stderr.writeln('generate_blog: </urlset> not found, skipping sitemap update.');
    return;
  }
  kept.insertAll(urlsetCloseIndex, blogUrls);
  file.writeAsStringSync(kept.join('\n'));
}

void main() {
  final postsDir = Directory('blog-posts');
  if (!postsDir.existsSync()) {
    stderr.writeln('generate_blog: blog-posts/ directory not found.');
    exit(1);
  }

  final posts = postsDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.md'))
      .map(_parsePost)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  if (posts.isEmpty) {
    stderr.writeln('generate_blog: no posts found in blog-posts/.');
    exit(1);
  }

  for (final p in posts) {
    final dir = Directory('web/blog/${p.slug}')..createSync(recursive: true);
    File('${dir.path}/index.html').writeAsStringSync(_renderPostPage(p));
    print('Wrote web/blog/${p.slug}/index.html');
  }

  File('web/blog/index.html').writeAsStringSync(_renderIndexPage(posts));
  print('Wrote web/blog/index.html (${posts.length} posts)');

  _updateSitemap(posts);
  print('Updated web/sitemap.xml');
}
