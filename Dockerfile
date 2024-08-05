# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Copy the HTML file to the Nginx default directory
COPY index.html /var/www/html/index.html

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

