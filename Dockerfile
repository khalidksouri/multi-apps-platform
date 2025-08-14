# Math4Child v4.2.0 - Dockerfile Production
FROM node:18-alpine AS base

# Dependencies
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production

# Builder
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Variables d'environnement pour le build
ENV NEXT_PUBLIC_APP_NAME=Math4Child
ENV NEXT_PUBLIC_APP_VERSION=4.2.0
ENV NEXT_PUBLIC_DOMAIN=www.math4child.com
ENV NEXT_PUBLIC_SUPPORT_EMAIL=support@math4child.com
ENV NEXT_PUBLIC_COMMERCIAL_EMAIL=commercial@math4child.com

RUN npm run build

# Runner
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000
ENV PORT=3000

CMD ["node", "server.js"]
