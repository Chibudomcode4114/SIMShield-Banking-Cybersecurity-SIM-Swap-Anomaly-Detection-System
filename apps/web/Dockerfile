FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --prefer-offline --no-audit

COPY . .

RUN npm run build

FROM node:22-alpine AS runner

WORKDIR /app

ENV PORT_WEB=3000 \
    NODE_ENV=production \
    NUXT_PUBLIC_API_BASE=http://localhost:3001

COPY package*.json ./
RUN npm install --omit=dev --prefer-offline --no-audit

COPY --from=builder /app/.nuxt ./.nuxt
COPY --from=builder /app/.output ./.output
COPY server.js ./

EXPOSE 3000

HEALTHCHECK --interval=15s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
