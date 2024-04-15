# Use the official Node.js image as the base
FROM node:alpine

# Install Git and OpenSSH (required for cloning from GitHub)
RUN apk add --no-cache git openssh

# Set the working directory inside the container
WORKDIR /app

# Define a build argument for the Git repository URL
ARG GIT_REPO

# Clone your React project from the provided GitHub repository
RUN git clone $GIT_REPO .

# Install project dependencies
RUN npm install

# Build the React project
RUN npm run build

# Expose port 80 (if your React app runs on a different port, adjust accordingly)
# EXPOSE 80
