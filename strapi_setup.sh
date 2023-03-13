#!/bin/bash

# Update the package manager
sudo apt update

# Install Nginx
sudo apt install nginx

# Start Nginx and enable it to start on boot
sudo systemctl start nginx
sudo systemctl enable nginx

# Install MySQL and secure the installation
sudo apt install mysql-server

# Configure MySQL
read -p "Enter MySQL root password: " mysql_password
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysql_password}';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql_secure_installation

# Prompt the user for MySQL credentials
echo "Enter MySQL username:"
read dbuser
echo "Enter MySQL password:"
read -s dbpass

# Create a new MySQL database for the Strapi application
echo "Enter a name for the new MySQL database:"
read dbname
sudo mysql -u$dbuser -p$dbpass -e "CREATE DATABASE $dbname;"

# sudo mysql_secure_installation
# ---------------------------------------------------------------------

# Start MySQL and enable it to start on boot
sudo systemctl start mysql
sudo systemctl enable mysql

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Verify that Node.js and npm are installed correctly
node -v
npm -v

# Install Strapi globally
sudo npm install -g strapi

# Create a new directory for the Strapi application
sudo mkdir /var/www/public_html

# Change the owner of the directory to the current user
sudo chown -R $USER:$USER /var/www/public_html

# Change into the new directory
cd /var/www/public_html

# Prompt the user for their GitHub credentials and the clone URL
echo "Enter your GitHub username:"
read username
echo "Enter your GitHub password or personal access token:"
read -s password
echo "Enter the GitHub clone URL for the Strapi application:"
read clone_url

# Clone the Strapi application from GitHub using the user's credentials
git clone https://$username:$password@$clone_url myapp

# Install the necessary dependencies
cd myapp
npm install

# Build the Strapi application
npm run build

# Start the Strapi application
npm start

# Prompt the user for the name of the Nginx configuration file
echo "Enter the name of the Nginx configuration file (e.g. myapp):"
read nginx_config_file

# Configure Nginx to serve the Strapi application
sudo rm /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-available/$nginx_config_file
sudo ln -s /etc/nginx/sites-available/$nginx_config_file /etc/nginx/sites-enabled/$nginx_config_file
sudo cat > /etc/nginx/sites-available/$nginx_config_file <<EOF
server {
    listen 80;
    server_name myapp.com;
    location / {
        proxy_pass http://localhost:1337;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Test the Nginx configuration
sudo nginx -t

# Restart Nginx to apply the changes
sudo systemctl restart nginx
