# Alternative to the Render static site (render.yaml): nginx serving web/.
# Works as a Render "Docker" web service or anywhere else.
FROM nginx:1.26-alpine

# The nginx image renders /etc/nginx/templates/*.template with envsubst at
# start-up, so the server listens on $PORT (set by Render; 8080 by default).
ENV PORT=8080
COPY nginx.conf /etc/nginx/templates/default.conf.template
COPY web /usr/share/nginx/html

EXPOSE 8080
