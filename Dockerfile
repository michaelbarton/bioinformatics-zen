FROM node:17.4-slim

ENV NODE_PATH /opt/node

RUN mkdir $NODE_PATH
ADD package.json package-lock.json /opt/node
RUN npm ci --prefix=$NODE_PATH

# See: https://www.docker.com/blog/keep-nodejs-rockin-in-docker/
ENV PATH $NODE_PATH/node_modules/.bin:$PATH

