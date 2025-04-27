# Step 1: Use a lightweight version of Nginx as the base image
FROM nginx:alpine

# Step 2: Copy the HTML file to the Nginx container's default directory
COPY ./index.html /usr/share/nginx/html/index.html

# Step 3: Expose port 80 to allow traffic to the web server
EXPOSE 80

# Step 4: Start the Nginx server when the container runs
CMD ["nginx", "-g", "daemon off;"]
