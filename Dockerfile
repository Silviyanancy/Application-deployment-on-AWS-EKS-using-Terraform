# Use the official Nginx image
FROM nginx:alpine

# Remove default nginx page and copy your site
COPY portfolio/index.html /usr/share/nginx/html/index.html
