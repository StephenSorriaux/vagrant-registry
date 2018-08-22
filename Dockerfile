FROM nginx:1.15.2-alpine

ENV NGINX_HOST="example.com www.example.com" NGINX_PORT="8081"

COPY nginx.conf /etc/nginx/nginx.conf.template
COPY start.sh /start.sh

RUN  mkdir -p /var/www \
  && chown -R nginx:nginx /var/www \
  && chmod +x /start.sh \
  && rm -rf /etc/nginx/conf.d/*

VOLUME ["/var/www"]

ENTRYPOINT ["/start.sh"]
