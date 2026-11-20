# Regisse website: static rebuild and repositioning

Date: 2026-11-20. Status: awaiting approval. Size: project.

## Intent and why

The current site is a Flutter web app (148 MB build, engine download before first paint, ~2,700 lines in `lib/ui/blocks.dart`). Regis wants it lightweight like anastudio.co, with a clearer offer and page animations.

New positioning: **Regisse is a solution provider. It sells ready-to-go products for African markets (Fidelia, a supermarket app, tourism, real estate, cooperatives, ...), already built, customised and live in weeks.** Primary visitor: a founder or business owner who wants an app built and would rather start from a working product than from a blank page.

## Goals

- Static site: HTML, CSS and vanilla JS, no framework, no runtime dependencies. Target under about 150 KB for the home page excluding images, and no client-side rendering.
- Home page that leads with the catalogue of products and a short "how we adapt one to you" process.
- Animations: scroll reveals, count-up proof numbers, product marquee, scripted phone or chat demo in the hero, "live in weeks" timeline. All disabled under `prefers-reduced-motion`.
- French (default) and English. Light and dark modes (existing toggle behaviour kept).
- SEO preserved: real HTML per page, sitemap, existing blog URLs unchanged.

## Non-goals and anti-goals

- No due diligence offer anywhere. Remove `/due-diligence-technique/` (including `exemple-rapport`) and `/en/tech-due-diligence/`. Redirect or 410 them and drop them from the sitemap. Remove mentions from the blog, footer and metadata.
- No German. Remove the German strings and any `hreflang="de"`.
- No framework or bundler. No backend or form-posting endpoint.
- Anti-goal: a page that looks like a generic "we build apps" agency. Every section should point at a concrete product or a concrete outcome.
- Anti-goal: claiming a product is "in production" or showing metrics that are not real.

## Constraints

- Hosting stays static (Render static site, or the nginx Docker image). The CSP currently allows `script-src 'self'` and `connect-src 'self'`, so there are no inline scripts and no third-party calls. The Flutter-specific `wasm-unsafe-eval`, `blob:` worker and no-cache rules for `flutter_*.js` go away.
- Contact goes through WhatsApp (`wa.me`, number from `lib/services/whatsapp_service.dart`) and `mailto:`, since there is no backend.
- The blog stays generated from `blog-posts/*.md` by `tool/generate_blog.dart`. It must keep working without Flutter installed (it is plain Dart, so keep it that way).
- Work on a new branch (for example `web/static-rebuild`). Never directly on `main`.

## Approaches considered

1. **Hand-written static site plus a small product data file (chosen by Regis).** Plain files. A short script generates product cards and pages from one data entry per product. About 100 KB, no new toolchain, matches anastudio's weight. Cost: adding a product means one data entry, and a little templating code to maintain.
2. Astro. Cleaner at 15+ products or many languages, but adds Node tooling and a build step. Rejected for now.
3. Extend the Dart blog generator to also build product pages from Markdown. No new tooling, but it means owning a templating system. Rejected.

## Design

**Pages** (FR at `/`, EN at `/en/`):

| Page | Purpose |
|---|---|
| Home | Hero, product marquee, product grid, process timeline, proof numbers, security note, contact CTA |
| `/produits/<slug>/` | One page per product: problem, what is included, screenshots, how it is adapted, CTA |
| `/securite/` | Kept, restyled |
| `/developpement-saas-mobile/` | Kept as the SEO page for custom builds, reframed as "customising a ready product" |
| Blog | Kept as is |
| Legal pages | `mentions-legales`, `confidentialite`, `conditions` kept |

**Home sections, in order:** hero (promise, two CTAs: "See the products" and WhatsApp, animated phone demo); marquee of product names; product grid (card per product with one-line outcome); "How it works" in 4 steps (pick, adapt, launch, support) as an animated timeline; proof numbers (count-up); security band; final CTA with WhatsApp and email.

**Files:** `web/index.html`, `web/en/index.html`, `web/site.css` (extends today's `pages.css`, keeps its colour variables), `web/site.js` (reveal, count-up, theme toggle, marquee pause, demo script), `data/products.json`, `tool/generate_site.dart` (cards and product pages, also calls the blog generator).

**Product data entry:** slug, name, one-line outcome (fr, en), problem, included features, status (`live`, `pilot`, `building`), screenshots, CTA text.

**Animation technique:** IntersectionObserver adds a class to reveal elements. Count-up uses `requestAnimationFrame`. The marquee is a CSS keyframe animation. The hero demo is a timed class sequence. Under `prefers-reduced-motion: reduce` everything shows in its final state with no motion.

**Removed:** `lib/`, platform folders (`android`, `ios`, `macos`, `linux`, `windows`), `pubspec.*`, `test/` (Flutter tests), `flutter_bootstrap.js`, `splash.js`, `patch-service-worker.sh`, `render-build.sh` Flutter steps, `build/`. All recoverable from git history. Update `render.yaml`, `Dockerfile`, `nginx.conf`, `README.md`, `devnotes.txt` accordingly. Replace the Flutter tests with a small check script (links resolve, no inline scripts, no "due diligence" text, sitemap matches pages).

## Decisions by Regis

- Remove due diligence entirely.
- Lead with founders who want an app built; positioning as solution provider with ready-to-go products.
- Option 1 (hand-written static, no framework).
- Drop German.

## My calls (please check)

- Contact by WhatsApp and `mailto:` only, no form.
- Product list taken from the repos: Fidelia, supermarket app, Akwaba Ivoire (tourism), Immoizi (real estate), Cabosse (cooperatives), petitGombo (mini-jobs). Flariane and the others are not included until Regis says what they are.
- Product `status` is shown honestly on each card. Nothing is called "in production" unless the data entry says `live`.
- Prices appear only as "from" tiers if Regis supplies them. No prices otherwise.
- `repositionnement.md` is replaced by a short real positioning note. The pasted chat transcript is archived under `docs/archive/`.

## Left to the builder

Visual design inside the existing palette (`#0b5fd0`, `#1e96ff`, `#ffb020`), typography (self-hosted, no web-font CDN), exact copy in French and English following the positioning above, image optimisation (reuse the `.webp` assets), the check script, and redirect handling for the removed due diligence URLs on the chosen host.
