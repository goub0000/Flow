# Use Node.js 18 Alpine for smaller image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy server and build files
COPY server.js ./
COPY build/web ./build/web

# Expose port
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
