FROM node:current-alpine

WORKDIR /usr/app

COPY package*.json ./

RUN npm install -g nodemon
RUN npm install --save ws
#RUN npm install

#CMD ["npm", "start"]