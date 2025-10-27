# ----------------------------
# Stage 1: Builder
# ----------------------------
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first (for build cache)
COPY package*.json ./

# Install only production dependencies
RUN npm install --omit=dev

# Copy app source code
COPY . .

# ----------------------------
# Stage 2: Runtime (minimal)
# ----------------------------
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy only built app & node_modules from builder
COPY --from=builder /app /app

# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Switch to non-root user
USER appuser

# Expose app port
EXPOSE 3000

# Default command
CMD ["npm", "start"]
