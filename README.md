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
`flutter build web --release --pwa-strategy=none` into `build/web`.
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
| `lib/components/app_palette.dart` | Light / dark colors and breakpoints (`context.palette`, `context.isMobile`) |
| `lib/i18n/translations.dart` | All FR / EN / DE texts |
| `lib/pages/` | Portfolio, tourism, travel, real-estate and leisure pages |
| `web/` | `index.html` (SEO, loading screen), icons, manifest |
| `docs/logo/` | Logo concepts (A is in use); `assets/images/logo.svg` is the source for all icons |
| `docs/archive/` | Older notes and reports kept for reference |

## Conventions

- Colors: use `context.palette.*` (theme-aware), never `Colors.white` for
  backgrounds or hard-coded grays; section text inherits the theme color.
- Breakpoints: use `context.isMobile` / `context.isDesktop` (read from
  `MediaQuery`, correct from the first frame).
- Texts: add a key to `translations.dart` in all three languages.
