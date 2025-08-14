# containers/docker/Dockerfile
# Classic multi-stage build without BuildKit-specific features
FROM node:20-alpine AS deps
WORKDIR /app
COPY app/package.json app/package-lock.json* ./ 
RUN npm ci --omit=dev

FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
COPY --from=deps /app/node_modules ./node_modules
COPY app/ .
USER node
EXPOSE 3000
CMD ["npm", "start"]
