# Regisse static site rebuild Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Flutter web app with a lightweight static FR/EN site that presents Regisse as a provider of ready-to-go products, with scroll and demo animations.

**Architecture:** Plain HTML/CSS/vanilla JS served from `web/`. `data/products.json` is the single source for product cards and product pages, rendered by `tool/generate_site.dart`, which also calls the existing blog generator. `tool/check_site.dart` is the test suite for the site (it fails the build on regressions).

**Tech Stack:** HTML, CSS, vanilla JS (IntersectionObserver, rAF), Dart scripts (no packages beyond what `tool/generate_blog.dart` already uses), Render static hosting / nginx.

**Spec:** `docs/superpowers/specs/2026-11-20-static-site-repositioning-design.md`

## Global Constraints

- Branch `web/static-rebuild`; never commit on `main`.
- Languages: French (root `/`) and English (`/en/`) only. No German, no `hreflang="de"`.
- No framework, bundler or npm dependency. No inline `<script>`; CSP stays `script-src 'self'`, `connect-src 'self'`.
- No "due diligence" content anywhere (pages, blog, footer, metadata, sitemap).
- Contact: WhatsApp (`wa.me`, number from `lib/services/whatsapp_service.dart`, read it before deleting `lib/`) and `mailto:` only. No form.
- All six products shown as available to clients; no "in production" claims, no prices, no invented metrics.
- Home page under 150 KB excluding images. Self-hosted fonts only.
- Palette: `#0b5fd0`, `#1e96ff`, `#ffb020`, existing CSS variables in `web/pages.css`; light and dark modes with the existing `data-theme` toggle.
- Animations disabled under `prefers-reduced-motion: reduce` (final state shown, no motion).
- Existing blog URLs unchanged.

## Review Focus

- JS disabled: all content must still be visible (reveal classes must be added by JS, never hidden by default in CSS without a `.js` guard).
- `prefers-reduced-motion`: counters show final values immediately, marquee static, demo shows end state.
- Old due diligence URLs (`/due-diligence-technique/`, `/en/tech-due-diligence/`) must return 404/redirect, not a stale page, and not be in `sitemap.xml`.
- Narrow phone widths (360 px): no horizontal scroll, marquee and demo do not overflow.
- A product entry missing an English field must fail the generator with a clear message, not emit "undefined".

## File Structure

- `data/products.json`: product entries (see Task 3 for schema).
- `tool/generate_site.dart`: renders product cards into both home pages and writes `web/produits/<slug>/index.html` and `web/en/products/<slug>/index.html`; then runs the blog generator.
- `tool/check_site.dart`: site checks (Task 1).
- `web/site.css`, `web/site.js`: shared styles and behaviour (replace `pages.css`, `pages.js`).
- `web/index.html`, `web/en/index.html`: home pages with `<!-- products:start -->`/`<!-- products:end -->` markers where cards are injected.
- `web/_redirects`-style handling lives in `render.yaml` (`routes` redirects) and `nginx.conf`.

---

### Task 1: Branch and site check script

**Files:**
- Create: `tool/check_site.dart`
- Modify: none

**Interfaces:**
- Produces: `dart run tool/check_site.dart` exits 0 when all checks pass, 1 otherwise, printing each failure as `FAIL <rule>: <path>`. Rules: `no-inline-script`, `no-due-diligence` (case-insensitive "due diligence" in any `web/**/*.html`, `blog-posts/*.md`, `web/sitemap.xml`), `no-german` (`hreflang="de"`, `lang="de"`), `links-resolve` (every internal `href`/`src` starting with `/` points at an existing file or `index.html` in a directory), `sitemap-matches` (every `<loc>` has a page, every non-legal page is listed), `html-weight` (home pages under 150 KB).

- [ ] **Step 1:** `git checkout -b web/static-rebuild`.
- [ ] **Step 2:** Implement `check_site.dart` with the rules above, walking `web/`.
- [ ] **Step 3:** Run `dart run tool/check_site.dart`. Expected: FAIL for `no-due-diligence` (existing pages) and possibly `no-inline-script`. This is the failing baseline the next tasks fix.
- [ ] **Step 4:** Commit `test: add static site checks`.

### Task 2: Remove due diligence, German and Flutter-only leftovers from content

**Files:**
- Delete: `web/due-diligence-technique/`, `web/en/tech-due-diligence/`, `repositionnement.md`, `ios/repositionnement.md` (move original `repositionnement.md` to `docs/archive/repositionnement-chat-2026-11.md` first)
- Modify: `web/sitemap.xml`, `blog-posts/*.md` and `web/blog/**` (remove mentions and links), footer snippets in `web/securite/index.html`, `web/developpement-saas-mobile/index.html`, legal pages
- Create: `docs/positioning.md` (about 15 lines: promise, audience, six products, tone; copied from the spec's Intent section)
- Modify: `render.yaml` and `nginx.conf`: redirect `/due-diligence-technique/*` and `/en/tech-due-diligence/*` to `/` with 301

**Interfaces:**
- Produces: check rules `no-due-diligence`, `no-german`, `sitemap-matches` pass.

- [ ] **Step 1:** `grep -ril "due diligence\|diligence" web blog-posts` to list every hit, edit each (rewrite sentence or remove link), delete the two page folders, update sitemap.
- [ ] **Step 2:** Add the two 301 redirects to `render.yaml` (`routes:` with `type: redirect`) and to `nginx.conf` (`location ^~ /due-diligence-technique/ { return 301 /; }` and the English one).
- [ ] **Step 3:** Run `dart run tool/check_site.dart`. Expected: `no-due-diligence`, `no-german`, `sitemap-matches` pass.
- [ ] **Step 4:** Commit `chore: remove due diligence and archive old positioning`.

### Task 3: Product data and generator

**Files:**
- Create: `data/products.json`, `tool/generate_site.dart`
- Modify: `tool/check_site.dart` (add rule `product-fields`)

**Interfaces:**
- Produces: `products.json` is a list of objects with keys `slug`, `name`, `outcome{fr,en}`, `problem{fr,en}`, `features{fr:[...],en:[...]}` (3 to 6 items each), `image` (path under `/assets/images/` or empty), `accent` (hex). Six entries: `fidelia`, `supermarche`, `akwaba-ivoire`, `immoizi`, `cabosse`, `petitgombo`.
- Produces: `dart run tool/generate_site.dart` renders cards between the markers in both home pages, writes the product pages (FR under `web/produits/<slug>/`, EN under `web/en/products/<slug>/`), runs `tool/generate_blog.dart`, and updates `sitemap.xml` entries for product pages. A missing key prints `products.json: <slug>.<key>.<lang> missing` and exits 1.
- Consumes: Task 4's page shell and CSS classes `.card`, `.product-page` (build the product page template to match Task 4's header/footer; implement the generator after Task 4's shell exists, or stub the shell and revisit in Task 4).

- [ ] **Step 1:** Write failing check `product-fields`: every entry has all keys in both languages; fails now (file absent).
- [ ] **Step 2:** Fill `products.json`. Read each product's README (`../fidelia`, `../supermarket-app`, `../tourismApp`, `../immoizi-core`, `../agriTechCMS`, `../mainsUtiles`) and write truthful FR and EN copy from what the README says it does. Do not state numbers or "in production".
- [ ] **Step 3:** Implement `generate_site.dart` with signature `Future<void> main(List<String> args)`; idempotent (re-running yields no diff).
- [ ] **Step 4:** Run `dart run tool/generate_site.dart && dart run tool/check_site.dart`. Expected: `product-fields` passes; second run produces `git diff --stat` empty.
- [ ] **Step 5:** Commit `feat: product data and site generator`.

### Task 4: Home pages, layout and styling

**Files:**
- Create: `web/site.css`, `web/index.html` (replace Flutter shell), `web/en/index.html`
- Modify: `web/404.html`

**Interfaces:**
- Produces: sections with ids `hero`, `produits`, `methode`, `preuves`, `securite`, `contact`; header with anchor nav, language link (FR/EN), theme toggle button `#theme-toggle`; classes later used by JS: `.reveal`, `[data-count]`, `.marquee`, `.demo`, `.timeline`. `site.css` starts from `pages.css` variables.
- Copy (FR source; EN mirrors it): hero "Des solutions prêtes à l'emploi pour les marchés africains. Choisissez un produit, nous l'adaptons, vous lancez en quelques semaines." CTAs "Voir les produits" (`#produits`) and "Parler sur WhatsApp" (`wa.me` link). Method steps: Choisir, Adapter, Lancer, Accompagner. `preuves` shows only facts that are true and countable from the repo (number of products = `6`, languages, platforms Android/iOS/web); do not invent client numbers.
- Page metadata: unique `<title>`, description, canonical, `hreflang` fr/en pairs, Open Graph, JSON-LD `Organization`.

- [ ] **Step 1:** Add check `home-structure`: both home pages contain the six section ids, one `<h1>`, canonical and hreflang pair. Run it, expect FAIL.
- [ ] **Step 2:** Build both pages and `site.css` (mobile-first, system font stack plus the existing self-hosted fonts in `assets/fonts` if present, dark mode via existing variables).
- [ ] **Step 3:** Run generator then checks. Expected: all rules pass.
- [ ] **Step 4:** Serve `python3 -m http.server 8080 --directory web`, open in Chrome, screenshot at 1280 px and 360 px, confirm no horizontal scroll and both modes readable.
- [ ] **Step 5:** Commit `feat: new static home pages`.

### Task 5: Animations and behaviour

**Files:**
- Create: `web/site.js`
- Modify: `web/site.css` (animation styles)

**Interfaces:**
- Consumes: classes from Task 4.
- Produces: `site.js` (no globals, one IIFE) implementing: adds `js` class to `<html>` immediately; `.reveal` elements get `.in` when 15% visible (CSS hides `.reveal` only under `.js`); `[data-count="N"]` counts from 0 to N over 1.2 s with ease-out once visible; `.marquee` CSS keyframe loop with content duplicated by JS and pause on hover/focus; `.demo` runs a timed sequence of 4 message bubbles with a typing indicator then loops after 6 s idle; `.timeline` fills its progress bar as it scrolls into view; theme toggle persists in `localStorage` key `theme` and sets `data-theme`. When `matchMedia('(prefers-reduced-motion: reduce)')` matches: no observers, counters set to final value, marquee animation `none`, demo shows all bubbles.

- [ ] **Step 1:** Add check `js-guard`: `site.css` never sets `.reveal{opacity:0}` outside a `.js` ancestor selector; expect FAIL until CSS is written correctly.
- [ ] **Step 2:** Implement JS and CSS.
- [ ] **Step 3:** Run checks. Expected: pass.
- [ ] **Step 4:** In Chrome (claude-in-chrome): load the page, scroll through, confirm reveals and counters fire; emulate reduced motion and confirm static final state; disable JS and confirm all content visible; read console, expect no errors.
- [ ] **Step 5:** Commit `feat: scroll, counter, marquee and demo animations`.

### Task 6: Existing pages onto the shared shell

**Files:**
- Modify: `web/securite/index.html`, `web/developpement-saas-mobile/index.html`, `web/mentions-legales/`, `web/confidentialite/`, `web/conditions/`, `tool/generate_blog.dart` templates, `web/blog/**` (regenerated)
- Delete: `web/pages.css`, `web/pages.js` once nothing references them

**Interfaces:**
- Consumes: `site.css`, `site.js`, header and footer markup from Task 4.
- `developpement-saas-mobile` retitled "Adapter un produit prêt à l'emploi ou développer sur mesure"; remove "MVP dès 250 000 FCFA" wording.

- [ ] **Step 1:** Swap stylesheet and script references, unify header and footer, update generator templates, regenerate blog.
- [ ] **Step 2:** Run `dart run tool/generate_site.dart && dart run tool/check_site.dart`. Expected: pass (`links-resolve` proves nothing points at deleted files).
- [ ] **Step 3:** Commit `refactor: move existing pages to shared shell`.

### Task 7: Remove Flutter and fix deployment

**Files:**
- Delete: `lib/`, `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `test/`, `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`, `.dart_tool/`, `.flutter-plugins*`, `build/`, `web/flutter_bootstrap.js`, `web/splash.js`, `web/manifest.json` only if unused (otherwise keep, remove Flutter fields), `patch-service-worker.sh`, `render-build.sh`
- Modify: `render.yaml` (`staticPublishPath: web`, `buildCommand: dart run tool/generate_site.dart` or none if generated output is committed (commit it), remove Flutter env vars, CSP without `wasm-unsafe-eval` and `blob:`, normal cache rules: HTML `no-cache`, `/assets` and CSS/JS one day), `nginx.conf` (same), `Dockerfile` (nginx only, copy `web/`), `.dockerignore`, `README.md`, `devnotes.txt`, `.gitignore`

**Interfaces:**
- Before deleting `lib/`, copy the WhatsApp number from `lib/services/whatsapp_service.dart` into the Task 4 links (verify they match) and keep `lib/` blog tool dependencies in mind: `tool/generate_blog.dart` must not import from `lib/`. If it does, move the shared code into `tool/` first.

- [ ] **Step 1:** Confirm `tool/*.dart` has no import from `lib/` or `package:flutter`; fix if it does.
- [ ] **Step 2:** Delete the files, update deploy config and README (how to run: `python3 -m http.server`, `dart run tool/generate_site.dart`, `dart run tool/check_site.dart`).
- [ ] **Step 3:** `docker build -t regisse-web . && docker run --rm -e PORT=8080 -p 8080:8080 regisse-web`, then `curl -sI localhost:8080/`, `/produits/fidelia/`, `/due-diligence-technique/` (expect 200, 200, 301) and `curl -s localhost:8080/ | wc -c` under 150000.
- [ ] **Step 4:** Run `dart run tool/check_site.dart`; expect all pass. Commit `chore: remove Flutter app and update deployment`.

### Task 8: Final verification

- [ ] **Step 1:** In Chrome, walk `/`, `/en/`, one product page each language, `/securite/`, `/blog/`; check console empty and Lighthouse-style basics (title, description, alt text on images).
- [ ] **Step 2:** `git status` clean, `dart run tool/check_site.dart` passes, summarise results to the user with the branch name. Do not merge or push without being asked.

---

## Self-review notes

- Spec coverage: positioning and product catalogue (3, 4), animations (5), due diligence and German removal (2), blog and legal kept (6), Flutter removal and deployment (7), contact by WhatsApp/mailto (4), archive of chat (2). `/developpement-saas-mobile/` reframing (6).
- Review Focus items are covered by: `js-guard` and the no-JS step (5), reduced-motion step (5), redirect curl (7) and `no-due-diligence` (2), 360 px check (4), `product-fields` (3).
