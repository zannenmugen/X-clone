# 1) Builder: install & build both front- and back-end
FROM node:18-alpine AS builder
WORKDIR /app

# install back-end deps
COPY package*.json ./
RUN npm install

# bring in your back-end code
COPY backend/ ./backend

# build the front-end
COPY frontend/ ./frontend/
RUN npm install --prefix frontend
RUN npm run build

# 2) Production image: only what we need at runtime
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=10000

# pull in production bits
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/backend ./backend
COPY --from=builder /app/frontend/dist ./frontend/dist

EXPOSE 10000
CMD ["npm","start"]
