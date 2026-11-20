# milikey Digital: website

Static website for milikey Digital (ready-to-go solutions for African markets). French at `/`, English at `/en/`. No framework: HTML, CSS and a little vanilla JavaScript in `web/`.

## Layout

| Path | What |
|---|---|
| `web/` | The site as served (committed, including generated pages) |
| `web/site.css`, `web/site.js` | Shared styles; theme toggle, scroll reveals, count-up, hero demo |
| `data/products.json` | One entry per product (FR and EN copy) |
| `blog-posts/*.md` | Blog posts (front matter + Markdown) |
| `tool/generate_site.dart` | Renders product cards and pages, shared header/footer, marquee, sitemap block; runs the blog generator |
| `tool/check_site.dart` | Site checks (broken links, inline scripts, sitemap, required fields, ...) |
| `docs/` | Positioning note, design spec and plan, archive |

## Work on it

```bash
dart pub get
python3 -m http.server 8080 --directory web      # preview
dart run tool/generate_site.dart                 # after editing data/products.json, blog posts, or header/footer
dart run tool/check_site.dart                    # must pass before committing
```

The header and footer live in `tool/generate_site.dart` and are injected into every page between `<!-- header:start -->` / `<!-- footer:start -->` markers.

## Add a product

Add an entry to `data/products.json` (slug, name, accent colour, `outcome`, `problem` and `features` in `fr` and `en`), then run the generator. A missing field stops it with a clear message.

## Blog

1. Add `blog-posts/<slug>.md` with front matter:
   ```
   ---
   title: Post title
   description: Meta description.
   excerpt: Shown on the blog index (optional).
   date: 2026-11-01
   readingMinutes: 7
   whatsappText: Pre-filled WhatsApp message (optional).
   ---
   Markdown body.
   ```
2. Run `dart run tool/generate_site.dart`.

## Deploy

`render.yaml` publishes `web/` as a Render static site (with security headers and redirects for the retired due diligence URLs). The `Dockerfile` serves the same folder with nginx.

## Licence

See `LICENSE`.
