# Use Node.js 18 Alpine for smaller image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy server file
COPY server.js ./

# Copy Flutter web build (create directory if needed)
RUN mkdir -p ./build/web
COPY build/web/ ./build/web/

# Expose port
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
