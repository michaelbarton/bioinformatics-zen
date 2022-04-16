# Image for building the site
FROM node:17.4-slim AS build
WORKDIR /mnt/src/
COPY package*.json ./
RUN npm ci
