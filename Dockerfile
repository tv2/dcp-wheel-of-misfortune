# Use the official Nginx image based on Alpine
FROM nginx:1.27.5-alpine

# Set the working directory
WORKDIR /usr/share/nginx/html

# Copy the static content to the Nginx default directory
COPY . /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]