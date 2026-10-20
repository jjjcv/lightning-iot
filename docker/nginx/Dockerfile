ARG NGINX_IMAGE=nginx:1.28-alpine
FROM ${NGINX_IMAGE}
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY payload/html/ /usr/share/nginx/html/
EXPOSE 80
