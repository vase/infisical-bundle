ARG TAG=latest
FROM docker.io/infisical/backend:${TAG} as backend
FROM docker.io/infisical/frontend:${TAG} as frontend

FROM docker.io/node:19-alpine as runner

RUN mkdir /app
RUN apk add --no-cache nginx wget
RUN npm i --unsafe-perm -g pm2@5.3.0

WORKDIR /app

COPY --from=backend /app /app/backend
COPY --from=frontend /app /app/frontend
RUN chown -R root:root /app
ENV npm_config_cache /app/.npm
RUN cd /app/frontend && npm i --unsafe-perm --platform=linux --arch=x64 --libc=musl sharp
RUN rm -rf /app/.npm
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/http.d/default.conf
COPY ecosystem.config.js /app/ecosystem.config.js

WORKDIR /app

RUN wget -O - https://github.com/DarthSim/hivemind/releases/download/v1.1.0/hivemind-v1.1.0-linux-amd64.gz | gunzip -c > hivemind
RUN chmod +x ./hivemind
COPY Procfile /app/Procfile

EXPOSE 8080

CMD ["/app/hivemind", "/app/Procfile"]