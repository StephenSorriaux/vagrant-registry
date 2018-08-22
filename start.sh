#!/bin/sh

envsubst "$(env | awk -F = '{printf " $$%s", $$1}')" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && exec nginx $@
