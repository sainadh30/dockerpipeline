# Use the official Ubuntu base image
FROM ubuntu:latest

# Install Nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose port 80 to the host
EXPOSE 80

# Command to run when the container starts
CMD ["nginx", "-g", "daemon off;"]

