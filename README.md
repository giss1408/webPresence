# Regisse__ #Business Solutions — website

Company website (Flutter web): digital solutions for projects in Africa.
French / English / German, light and dark mode.

## Develop

```bash
flutter pub get
flutter run -d chrome
```

Requires Flutter **3.24.2** (the version pinned in `render.yaml` and `Dockerfile`).

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
3. Add your domain under **Settings → Custom Domains** (e.g. `regisse.de`).

`render-build.sh` installs the pinned Flutter SDK and runs
`flutter build web --release --pwa-strategy=offline-first --web-renderer auto`
into `build/web`. `auto` gives phones Flutter's HTML renderer, which skips
the 1.5 MB CanvasKit download (half the data on a first visit); desktops keep
CanvasKit.
The service worker caches the site on visitors' devices: repeat visits open
almost instantly, and after a deploy returning visitors see the new version
on their next visit. `web/flutter_bootstrap.js` starts the app without
waiting for the service worker and installs it after the first frame, and
`patch-service-worker.sh` (run after the build) makes its install revalidate
instead of re-downloading, so a first visit fetches `main.dart.js` only once.
Build locally the same way before testing offline behaviour:
`flutter build web --release --pwa-strategy=offline-first --web-renderer auto && ./patch-service-worker.sh`.
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
| `lib/ui/showcase/` | Live phone demo (scripted Akwaba / Djassa / Immoizi flows, iOS ⇄ Android), offline-sync animation, screen-recording player |
| `lib/components/motion.dart` | Scroll animations: `Reveal` (fade/slide in), `CountUp` (stats), `OnScreen` (pauses loops off screen) |
| `lib/components/app_palette.dart` | Light / dark colors and breakpoints (`context.palette`, `context.isMobile`) |
| `lib/i18n/translations.dart` | All FR / EN / DE texts |
| `lib/pages/` | Portfolio page |
| `web/` | `index.html` (SEO, loading screen), icons, manifest |
| `docs/logo/` | Logo concepts and the animated logo; `assets/images/logo.svg` (R on the flag of Côte d'Ivoire) is the source for all icons (`rsvg-convert` it into `web/icons/`) |
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
