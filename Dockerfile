# Dockerfile

FROM node:14

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install

# Bundle app source
COPY . .

# Expose the port the app runs on (optional, but useful for reference)
EXPOSE 3000

# Command to run the app with debugging enabled
CMD [ "node", "--inspect=0.0.0.0:9229", "src/index.js" ]
