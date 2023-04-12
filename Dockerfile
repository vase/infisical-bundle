ARG TAG=latest
FROM docker.io/infisical/backend:${TAG} as backend
FROM docker.io/infisical/frontend:${TAG} as frontend

FROM docker.io/node:16-alpine as runner

RUN addgroup --system --gid 1001 infisical
RUN adduser --system --uid 1001 infisical

RUN chown -R infisical:infisical $(npm config get prefix)/lib/node_modules
RUN mkdir /app && chown -R infisical:infisical /app
RUN apk add --no-cache nginx
RUN npm i -g pm2@5.3.0
RUN chown -R infisical:infisical /usr/local/bin/pm2

USER infisical
WORKDIR /app

COPY --chown=infisical:infisical --from=backend /app /app/backend
COPY --chown=infisical:infisical --from=frontend /app /app/frontend
RUN cd /app/frontend && npm i --platform=linux --arch=x64 --libc=musl sharp
COPY --chown=infisical:infisical nginx.conf /etc/nginx/nginx.conf
COPY ecosystem.config.js /app/ecosystem.config.js

EXPOSE 8080

CMD ["pm2-runtime", "ecosystem.config.js"]