# containers/buildkit/Dockerfile
#syntax=docker/dockerfile:1.7-labs

# Demonstrates BuildKit features: cache mounts and secrets
FROM node:20-alpine AS deps
WORKDIR /app
# Optional secret for private registry/npm: pass at build with --secret id=npmrc,src=.npmrc
COPY app/package.json app/package-lock.json* ./
RUN --mount=type=cache,target=/root/.npm \
    --mount=type=secret,id=npmrc,dst=/root/.npmrc,required=false \
    npm ci --omit=dev

FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
COPY --from=deps /app/node_modules ./node_modules
COPY app/ .
# Show layer squashing benefit by excluding dev deps already
USER node
EXPOSE 3000
CMD ["npm", "start"]
