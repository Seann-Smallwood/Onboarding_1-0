# Use Node.js 22 Alpine for smaller image size
FROM node:22-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files for better layer caching
COPY package*.json ./

# Install all dependencies (including devDependencies for building)
RUN npm ci

# Copy source code
COPY . .

# Build the TypeScript project
RUN npm run compile

# Production stage
FROM node:22-alpine AS production

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev && npm cache clean --force

# Copy built application from builder stage
COPY --from=builder /app/lib ./lib

# Copy configuration files
COPY config ./config

# Copy public assets (if needed by the app)
COPY public ./public

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Change ownership of the app directory to nodejs user
RUN chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose port 8080 (Cloud Run requirement)
EXPOSE 8080

# Set environment variable for port
ENV PORT=8080
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').request('http://localhost:8080/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1)).end()"

# Start the application
CMD ["npm", "start"]

