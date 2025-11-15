# Use Node.js 18 Alpine for smaller image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy everything from repository
COPY . .

# Install dependencies
RUN npm install --production

# Expose port
EXPOSE 8080

# Start the server
CMD ["node", "server.js"]
