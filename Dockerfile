ARG TAG=latest
FROM docker.io/infisical/backend:${TAG} as backend
FROM docker.io/infisical/frontend:${TAG} as frontend

FROM docker.io/node:16-alpine as runner

RUN addgroup -g 101 -S nginx
RUN adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx
RUN mkdir /var/cache/nginx && chown -R nginx:nginx /var/cache/nginx

RUN chown -R nginx:nginx $(npm config get prefix)/lib/node_modules
RUN mkdir /app && chown -R nginx:nginx /app
RUN apk add --no-cache nginx
RUN npm i -g pm2@5.3.0
RUN chown -R nginx:nginx /usr/local/bin/pm2

USER nginx
WORKDIR /app

COPY --chown=nginx:nginx --from=backend /app /app/backend
COPY --chown=nginx:nginx --from=frontend /app /app/frontend
RUN cd /app/frontend && npm i --platform=linux --arch=x64 --libc=musl sharp
COPY --chown=nginx:nginx nginx.conf /etc/nginx/conf.d/default.conf
COPY ecosystem.config.js /app/ecosystem.config.js

EXPOSE 8080

CMD ["pm2-runtime", "ecosystem.config.js"]