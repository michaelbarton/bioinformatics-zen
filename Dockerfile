# Image for building the site
FROM node:22-slim AS build
WORKDIR /mnt/src/
COPY package*.json ./
RUN npm ci
