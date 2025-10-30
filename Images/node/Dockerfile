# FROM node:current-alpine

# WORKDIR /usr/app

# COPY package*.json ./

# RUN npm install -g nodemon
# RUN npm install --save ws
FROM node:current-alpine

WORKDIR /usr/app

# Copy package files and install deps
COPY package*.json ./
RUN npm install

# Copy the rest of the application code (including server.js)
COPY . .

# Expose the port your app listens on
EXPOSE 8000

# Start the app
CMD ["npm", "start"]
