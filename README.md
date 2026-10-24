# Regisse - Mobile Business Technologies — website

Company website (Flutter web): digital solutions for projects in Africa.
French / English / German, light and dark mode.

## Develop

```bash
flutter pub get
flutter run -d chrome
```

Requires Flutter **3.24.2** (the version pinned in `render.yaml` and `Dockerfile`).

## Blog

The blog (`/blog/`) is static HTML generated from Markdown, so publishing a
post never touches hand-written HTML, the post list, or the sitemap.

To publish a new post:

1. Add `blog-posts/<slug>.md` with front matter, e.g.:
   ```
   ---
   title: Post title
   description: Meta description and JSON-LD headline source.
   ogDescription: Shorter description for social previews (optional).
   excerpt: Shown on the blog index under the title (optional).
   date: 2026-11-01
   readingMinutes: 7
   whatsappText: Pre-filled message for the post's WhatsApp CTA (optional).
   secondaryLinkHref: /blog/            (optional)
   secondaryLinkLabel: Tous les articles (optional)
   ---
   Markdown body. Raw HTML blocks (e.g. a custom `<div class="offer">`)
   pass through untouched for the rare post that needs one.
   ```
2. Run `dart run tool/generate_blog.dart` — it writes
   `web/blog/<slug>/index.html`, rebuilds `web/blog/index.html` (newest
   first, grouped by year) with each post's table of contents generated
   from its `##` headings, and updates the blog entries in
   `web/sitemap.xml`.
3. Commit `blog-posts/<slug>.md` and the regenerated files, and push —
   Render auto-deploys. (`render-build.sh` also runs the generator before
   every build, so a forgotten regeneration still ships correctly.)

To edit a post, edit its `.md` file and re-run the generator; never hand-edit
the generated `web/blog/**/index.html` files, they get overwritten.

## Check before pushing

```bash
flutter analyze        # must report "No issues found"
flutter test           # layout tests: every page, 360–1440 px, light + dark, FR/EN/DE
```

`test/layout_test.dart` renders each page at phone, tablet and desktop widths
and fails on any overflow, so layout regressions are caught before deploy.

## Deploy on Render

The site is a **Render Static Site** (served from Render's CDN; no server to
keep warm, free tier friendly), described in `render.yaml`:

1. Push this folder to a Git repository (GitHub / GitLab / Bitbucket).
   If it is not the repository root, add `rootDir: <path>` to the service in
   `render.yaml`.
2. In Render: **New → Blueprint**, pick the repository, apply.
3. Add your domain under **Settings → Custom Domains** (e.g. `mobile-technologies.milikey-energy.com`).

`render-build.sh` installs the pinned Flutter SDK and runs
`flutter build web --release --pwa-strategy=offline-first --no-web-resources-cdn`
into `build/web`. CanvasKit and all fonts are served from the site itself, so
visitors' browsers never contact Google (see the privacy notice).
The service worker caches the site on visitors' devices: repeat visits open
almost instantly, and after a deploy returning visitors see the new version
on their next visit. `web/flutter_bootstrap.js` starts the app without
waiting for the service worker and installs it after the first frame, and
`patch-service-worker.sh` (run after the build) makes its install revalidate
instead of re-downloading, so a first visit fetches `main.dart.js` only once.
Build locally the same way before testing offline behaviour:
`flutter build web --release --pwa-strategy=offline-first --no-web-resources-cdn && ./patch-service-worker.sh`.
`render.yaml` also sets the security headers (CSP, frame, referrer and
permissions policies) and the cache rules: the app entry points
(`index.html`, `main.dart.js`, …) are revalidated on every visit because
Flutter's file names are not content-hashed; images and CanvasKit are cached
for an hour (so a changed image or logo reaches visitors quickly).

To change the Flutter version, update `FLUTTER_VERSION` in `render.yaml` and
the image tag in `Dockerfile` together.

### Alternative: Docker

`Dockerfile` builds the same bundle and serves it with nginx on `$PORT`
(default 8080), with the same headers (`nginx.conf`). Use it for a Render
"Docker" web service or any container host.

## Project layout

| Path | Contents |
| --- | --- |
| `lib/main.dart` | App, routes, home page section order |
| `lib/ui/blocks.dart` | Home page sections, header, footer |
| `lib/ui/carousel/` | Hero carousel |
| `lib/ui/section_nav.dart` | Menu / in-page scrolling anchors |
| `lib/ui/showcase/` | Live phone demo (scripted Akwaba / Fidelia / Immoizi flows, iOS ⇄ Android), offline-sync animation, screen-recording player |
| `lib/components/motion.dart` | Scroll animations: `Reveal` (fade/slide in), `CountUp` (stats), `OnScreen` (pauses loops off screen) |
| `lib/components/app_palette.dart` | Light / dark colors and breakpoints (`context.palette`, `context.isMobile`) |
| `lib/i18n/translations.dart` | All FR / EN / DE texts |
| `lib/pages/` | Portfolio page |
| `web/` | `index.html` (SEO, loading screen), icons, manifest, static pages (`blog/`, `developpement-saas-mobile/`, `due-diligence-technique/`, legal pages) |
| `blog-posts/*.md` | Blog post source (see **Blog** above); `tool/generate_blog.dart` renders them into `web/blog/` |
| `docs/logo/` | Logo concepts and the animated logo; `assets/images/logo.svg` is the source for all icons (`rsvg-convert` it into `web/icons/`) |
| `lib/components/animated_logo.dart` | Animated logo (header, footer): the brand text (`brandText`) typed out of the R; the loading screen in `web/index.html` and `docs/logo/logo-animated*.svg` repeat the same animation |
| `docs/archive/` | Older notes and reports kept for reference |

## Conventions

- Colors: use `context.palette.*` (theme-aware), never `Colors.white` for
  backgrounds or hard-coded grays; section text inherits the theme color.
- Breakpoints: use `context.isMobile` / `context.isDesktop` (read from
  `MediaQuery`, correct from the first frame).
- Texts: add a key to `translations.dart` in all three languages.
- Motion: wrap new sections in `Reveal`; looping animations must pause
  off screen (`OnScreen(once: false)`) and respect
  `MediaQuery.disableAnimationsOf` (the OS "reduce motion" setting).

## Live demo and screen recordings

The phone on the home and portfolio pages is Flutter code, not a video:
each app's screens and script (which screen, what the finger taps, which
notification appears) are in `lib/ui/showcase/demo_screens.dart`. Screens
use the adaptive widgets in `demo_kit.dart`, so they follow the iOS /
Android toggle.

To add a real screen recording to a portfolio card:

1. Record the app (e.g. `xcrun simctl io booted recordVideo akwaba.mp4` or
   `adb shell screenrecord`), keep it 8–15 s, muted, H.264 MP4, ideally
   under 2 MB (`ffmpeg -i in.mp4 -an -vf scale=540:-2 -crf 30 out.mp4`).
2. Save it as `assets/videos/<app>.mp4` and add `- assets/videos/` under
   `assets:` in `pubspec.yaml`.
3. Set `recording: 'assets/videos/<app>.mp4'` on the project in
   `lib/pages/portfolio_page.dart`. A "Watch the video" button appears; the
   file is only downloaded when a visitor opens it. It is served from the
   site itself, which the CSP (`default-src 'self'`) already allows.
