# Stage 1: Build
FROM node:20 AS builder

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

# Stage 2: Prune dev dependencies
FROM node:20 AS prune

WORKDIR /app

COPY --from=builder /app/package.json /app/yarn.lock ./

RUN yarn install --production --frozen-lockfile

# Stage 3: Final image
FROM gcr.io/distroless/nodejs20-debian12

WORKDIR /app

COPY --from=prune /app/node_modules ./node_modules
COPY --from=builder /app .

CMD ["index.js"]