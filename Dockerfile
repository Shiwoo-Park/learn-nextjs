# Usage
# docker build --build-arg SERVICE_ENV=dev -t learn-nextjs:dev .
# docker run -d --name learn-nextjs -p 3000:3000 learn-nextjs:dev

# Install dependencies only when needed
FROM node:20.15.0-alpine AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile

# Rebuild the source code only when needed
FROM node:20.15.0-alpine AS builder
WORKDIR /app
COPY . .
ARG SERVICE_ENV
RUN if [ "$SERVICE_ENV" = "prod" ]; then export NODE_ENV=production; else export NODE_ENV=development; fi
COPY ./dotenv/.env.${SERVICE_ENV} ./.env
COPY --from=deps /app/node_modules ./node_modules
RUN npm install -g pnpm
RUN pnpm run build

# Production image, copy all the files and run pm2
FROM node:20.15.0-alpine AS runner
WORKDIR /app

# Install PM2
RUN npm install -g pm2

# Copy the built files and node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

# Use PM2 to run the application
CMD ["pm2-runtime", "start", "npm", "--", "start"]