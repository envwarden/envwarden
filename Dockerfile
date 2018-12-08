FROM node:11-alpine

LABEL maintainer="envwarden"

RUN apk update && apk add bash wget jq

RUN npm install -g @bitwarden/cli

ADD envwarden /usr/local/bin

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["envwarden"]
