ARG TAG=latest
FROM docker.io/infisical/backend:${TAG} as backend
FROM docker.io/infisical/frontend:${TAG} as frontend

FROM docker.io/node:16-alpine as runner

RUN npm i -g pm2@5.3.0

WORKDIR /app

COPY --from=backend /app /app/backend
COPY --from=frontend /app /app/frontend
COPY proxy /app/proxy
RUN cd proxy && npm ci
COPY ecosystem.config.js /app/ecosystem.config.js

EXPOSE 8080

CMD ["pm2-runtime", "ecosystem.config.js"]