FROM node:17.4-slim

WORKDIR /mnt/src/
COPY package*.json ./
RUN npm ci

