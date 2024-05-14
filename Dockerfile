# Use the specified Home Assistant addon base image
ARG BUILD_FROM=ghcr.io/hassio-addons/ubuntu-base:9.0.5
FROM $BUILD_FROM

ARG NVM_VERSION
ARG NODE_VERSION
ARG MONGODB_VERSION

# Install MongoDB, NVM, Node.js, clean up in a single RUN to reduce layers
RUN apt-get update && \
    apt-get install -y gnupg curl ca-certificates && \
    curl -fsSL https://www.mongodb.org/static/pgp/server-${MONGODB_VERSION}.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-${MONGODB_VERSION}.gpg && \
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-${MONGODB_VERSION}.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/${MONGODB_VERSION} multiverse" > /etc/apt/sources.list.d/mongodb-org-${MONGODB_VERSION}.list && \
    apt-get install -y mongodb-org && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install ${NODE_VERSION} && \
    nvm use ${NODE_VERSION} && \
    nvm alias default ${NODE_VERSION} && \
    apt-get purge -y gnupg curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
