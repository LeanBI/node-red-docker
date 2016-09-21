FROM node:4

# Home directory for Node-RED application source code.
RUN mkdir -p /usr/src/node-red

# User data directory, contains flows, config and nodes.
RUN mkdir /data

WORKDIR /usr/src/node-red

# Add node-red user so we aren't running as root.
RUN useradd --home-dir /usr/src/node-red --no-create-home node-red \
    && chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red

USER node-red

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/
COPY settings.js /data
RUN npm install \
    && npm install node-red-dashboard \
                && node-red-contrib-fft \
                && node-red-contrib-binary \
                && node-red-contrib-aws 

# User configuration directory volume
#VOLUME ["/data"]
#VOLUME ["/usr/src/node-red/node_modules/node-red-dashboard"]
EXPOSE 1880

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json

CMD ["npm", "start", "--", "--userDir", "/data"]
