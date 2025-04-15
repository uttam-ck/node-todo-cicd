# Node Base Image
FROM node:12.2.0-alpine

# Install OpenSSH
RUN apk update && apk add --no-cache openssh

# Add Public Key directly in Dockerfile
RUN mkdir -p /root/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdxTdtINTJYUWNtNAPKqmEjNLhen8+x7gZl3ZfmP15Ip6L1VQTjgeDLLJ3g+EMmcgWOfFPS1IPdd8+Ky+OLYuPILiuoXaZnvHQDh4z+tLSauxltIhbjLLs44tFu3wDcdhDOfzr+tLDjIIzCi5ZzPI4woz720x6u9ivnXHZz1GHUc5EVAE7RB6YOk205eVXnLrj7guDsWJAS4FdH+c7/svzDik181a+kTIgmBraiQlwdKTwUgOCnh1UEonCvTG4bL8MAvpuZjzAVvIvEfbYbD0gj1EUbv/Uj31ysTDC11i1ubJQ2cl0YdONnJCBSUwx/nfD7+yGB20XrPX0ZmOKb/68zgWmYYZ9gaNiz+vC6I5/1ziO/XxFdv8nVh7vnZKxkhqBh5s/bAxFLgPawLIv43zUDLkI6luYF70WjwRjeB9BIRhWrTVr/V1GkLT+InEm+FwRYVUXnGRmWGECL6O0jLFzcsAUgtjRoeQfFDQuEK94BuDBLoTLdSVREcguBaDvUWc= ubuntu@ip-172-31-18-94" > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
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
