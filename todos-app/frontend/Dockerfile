#Only for development. Not suitable for production use.
FROM node:lts-bullseye-slim

WORKDIR /app
COPY . .
RUN npm install

CMD [ "npm", "run", "serve" ]
