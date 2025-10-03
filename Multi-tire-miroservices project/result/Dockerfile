FROM node:18-slim

# ARG UID=10001
WORKDIR /usr/local/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm ci && \
    npm cache clean --force

RUN npm install -g nodemon

COPY . .

EXPOSE 4000

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
