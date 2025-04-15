# Use Node base image
FROM node:12.2.0-alpine

# Install OpenSSH
RUN apk update && apk add --no-cache openssh

# Create SSH directory and set authorized keys
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdxTdtINTJYUWNtNAPKqmEjNLhen8+x7gZl3ZfmP15Ip6L1VQTjgeDLLJ3g+EMmcgWOfFPS1IPdd8+Ky+OLYuPILiuoXaZnvHQDh4z+tLSauxltIhbjLLs44tFu3wDcdhDOfzr+tLDjIIzCi5ZzPI4woz720x6u9ivnXHZz1GHUc5EVAE7RB6YOk205eVXnLrj7guDsWJAS4FdH+c7/svzDik181a+kTIgmBraiQlwdKTwUgOCnh1UEonCvTG4bL8MAvpuZjzAVvIvEfbYbD0gj1EUbv/Uj31ysTDC11i1ubJQ2cl0YdONnJCBSUwx/nfD7+yGB20XrPX0ZmOKb/68zgWmYYZ9gaNiz+vC6I5/1ziO/XxFdv8nVh7vnZKxkhqBh5s/bAxFLgPawLIv43zUDLkI6luYF70WjwRjeB9BIRhWrTVr/V1GkLT+InEm+FwRYVUXnGRmWGECL6O0jLFzcsAUgtjRoeQfFDQuEK94BuDBLoTLdSVREcguBaDvUWc= ubuntu@ip-172-31-18-94" > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    ssh-keygen -A

# Working Directory
WORKDIR /node

# Copy the app code into the container
COPY . .

# Install dependencies and run tests
RUN npm install
RUN npm run test

# Expose SSH (22) and app (8000) ports
EXPOSE 8000 22

# Set entrypoint to start SSH service in the foreground and the Node.js app
CMD ["/bin/sh", "-c", "/usr/sbin/sshd -D & node app.js"]
