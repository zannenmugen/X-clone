# 1. Build frontend
FROM node:18-alpine AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# 2. Build backend
FROM node:18-alpine AS backend-build
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install
COPY backend/ ./

# 3. Final image: serve both
FROM node:18-alpine
WORKDIR /app

# Copy backend code
COPY --from=backend-build /app/backend ./backend

# Copy built frontend into backend’s static folder
COPY --from=frontend-build /app/frontend/build ./backend/public

# If you use Express/static to serve public files, fine.  
# Otherwise install nginx or a static file server here.

EXPOSE 10000
ENV PORT=10000

# Start your combined app
CMD ["node", "backend/index.js"]
