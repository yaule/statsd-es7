FROM node:12-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install python
RUN apk add --no-cache --update g++ gcc libgcc libstdc++ linux-headers make python git curl

# Setup node envs
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

# download statsd
RUN git clone https://github.com/statsd/statsd.git /usr/src/app

# install modules
RUN npm install && \
    npm audit fix && \
    npm install && \
    npm install statsd-elasticsearch7-backend named-regexp && \
    npm cache clean --force -I && \
    curl -s https://raw.githubusercontent.com/DispatchBot/statsd-elasticsearch-backend/master/lib/regex_format.js -o node_modules/statsd-elasticsearch7-backend/lib/regex_format.js

#COPY ./config.js config.js

# Expose required ports
EXPOSE 8125/udp
EXPOSE 8126

# Start statsd
CMD [ "node", "stats.js", "config.js" ]
