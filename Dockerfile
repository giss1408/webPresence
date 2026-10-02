# Alternative to the Render static site (render.yaml): a container serving the
# same build with nginx. Works as a Render "Docker" web service or anywhere else.

# ─── Stage 1: Build ───────────────────────────────────────────────────────────
# Keep in sync with FLUTTER_VERSION in render.yaml.
FROM ghcr.io/cirruslabs/flutter:3.24.2 AS builder

WORKDIR /app

# Resolve dependencies first so this layer is cached until pubspec.* change.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
RUN flutter build web --release --pwa-strategy=offline-first \
    && ./patch-service-worker.sh

# ─── Stage 2: Serve ───────────────────────────────────────────────────────────
FROM nginx:1.26-alpine AS runner

# The nginx image renders /etc/nginx/templates/*.template with envsubst at
# start-up, so the server listens on $PORT (set by Render; 8080 by default).
ENV PORT=8080
COPY nginx.conf /etc/nginx/templates/default.conf.template
COPY --from=builder /app/build/web /usr/share/nginx/html

EXPOSE 8080
