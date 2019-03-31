FROM node:lts-alpine AS build

RUN mkdir -p /packages
COPY package.json /packages/package.json
COPY package-lock.json /packages/package-lock.json

RUN cd /packages && CI=true npm install && \
  mkdir -p /app/frontend && ln -s /packages/node_modules /app/frontend/node_modules

COPY . /app/frontend
WORKDIR /app/frontend
RUN npm run build

FROM node:lts-alpine
EXPOSE 5000
RUN npm install -g serve
COPY --from=build /app/frontend/dist/angularWhatever ./build

ENTRYPOINT serve -s build