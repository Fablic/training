FROM node:lts-bullseye-slim as build

WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM nginx:1.21 as prod
WORKDIR /app
COPY --from=build /app/dist .
COPY nginx.conf /etc/nginx/nginx.conf