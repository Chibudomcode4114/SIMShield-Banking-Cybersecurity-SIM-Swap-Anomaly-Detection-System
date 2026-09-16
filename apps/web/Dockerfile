FROM node:22-alpine

WORKDIR /app

ENV PORT_WEB=3000 \
    NODE_ENV=production \
    NUXT_PUBLIC_API_BASE=http://localhost:3001

COPY package*.json ./
RUN npm install --only=production

COPY . .

EXPOSE 3000

HEALTHCHECK --interval=15s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
