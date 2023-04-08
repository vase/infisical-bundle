ARG TAG=latest
FROM docker.io/infisical/backend:${TAG} as backend
FROM docker.io/infisical/frontend:${TAG} as frontend

FROM docker.io/node:16-alpine as runner

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nodejs

RUN chown -R nodejs:nodejs $(npm config get prefix)/lib/node_modules
RUN mkdir /app && chown -R nodejs:nodejs /app
RUN npm i -g pm2@5.3.0
RUN chown -R nodejs:nodejs /usr/local/bin/pm2

USER nodejs
WORKDIR /app

COPY --chown=nodejs:nodejs --from=backend /app /app/backend
COPY --chown=nodejs:nodejs --from=frontend /app /app/frontend
RUN cd /app/frontend && npm i --platform=linux --arch=x64 --libc=musl sharp
COPY --chown=nodejs:nodejs proxy /app/proxy
RUN cd proxy && npm ci
COPY ecosystem.config.js /app/ecosystem.config.js

EXPOSE 8080

CMD ["pm2-runtime", "ecosystem.config.js"]