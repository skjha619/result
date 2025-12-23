FROM node:24-slim AS build
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/app
COPY package*.json ./
RUN npm ci
COPY . .

FROM node:24-slim AS final
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/app
COPY --from=build /usr/local/app/node_modules ./node_modules
COPY --from=build /usr/local/app ./
ENV NODE_ENV=production
ENV PORT=80
EXPOSE 80
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
