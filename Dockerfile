# Stage 1: Build React frontend
FROM node:22-alpine AS client-builder

WORKDIR /app

COPY client/package*.json ./client/

WORKDIR /app/client

RUN npm ci

COPY client/ ./

RUN npm run build


# Stage 2: Set up backend
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY index.js ./
COPY routes ./routes
COPY models ./models

COPY --from=client-builder /app/client/dist ./client/dist

EXPOSE 3000

CMD ["node", "index.js"]