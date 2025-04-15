# Node Base Image
FROM node:12.2.0-alpine

# Install OpenSSH
RUN apk update && apk add --no-cache openssh

# Create SSH directory and add your public key
RUN mkdir -p /root/.ssh
COPY id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh && \
    ssh-keygen -A

# Working Directory
WORKDIR /node

# Copy the Code
COPY . .

# Install dependencies and run tests
RUN npm install
RUN npm run test

# Expose SSH and app ports
EXPOSE 8000 22

# Start sshd and your app
CMD ["/bin/sh", "-c", "/usr/sbin/sshd && node app.js"]
