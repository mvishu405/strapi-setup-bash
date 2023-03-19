#!/bin/bash

# Create public_html
mkdir public_html

# Script to Generate RSA Key
generate_rsa_key() {
    # Prompt the user for the location to save the key
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
    
    echo "RSA key generated at ~/.ssh/id_rsa"
}

# Script to Create Strapi .env File
create_strapi_env_file() {
    # Prompt the user for the necessary environment variables
    read -p "Enter the database client (default: mysql): " db_client
    db_client=${db_client:-mysql}
    
    read -p "Enter the database host (default: localhost): " db_host
    db_host=${db_host:-localhost}
    
    read -p "Enter the database port (default: 3306): " db_port
    db_port=${db_port:-3306}
    
    read -p "Enter the database name: " db_name
    
    read -p "Enter the database username: " db_username
    
    read -p "Enter the database password: " db_password
    
    read -p "Enter the database schema (optional): " db_schema
    
    read -p "Enter the admin URL (default: http://localhost:1337): " admin_url
    admin_url=${admin_url:-http://localhost:1337}
    
    read -p "Enter the public URL (default: http://localhost:1337): " public_url
    public_url=${public_url:-http://localhost:1337}
    
    read -p "Enter the server host (default: 0.0.0.0): " server_host
    server_host=${server_host:-0.0.0.0}
    
    read -p "Enter the server port (default: 1337): " server_port
    server_port=${server_port:-1337}
    
    read -p "Enter the server proxy (optional): " server_proxy
    
    read -p "Enter the NODE_ENV value (default: development): " node_env
    node_env=${node_env:-development}
    
    # Generate random values for APP_KEYS, API_TOKEN_SALT, ADMIN_JWT_SECRET, and JWT_SECRET if not provided
    if [[ -z "${APP_KEYS}" ]]; then
        app_keys=$(openssl rand -hex 64)
        echo "Generated random value for APP_KEYS: $app_keys"
    else
        app_keys="${APP_KEYS}"
    fi
    
    if [[ -z "${API_TOKEN_SALT}" ]]; then
        api_token_salt=$(openssl rand -hex 16)
        echo "Generated random value for API_TOKEN_SALT: $api_token_salt"
    else
        api_token_salt="${API_TOKEN_SALT}"
    fi
    
    if [[ -z "${ADMIN_JWT_SECRET}" ]]; then
        admin_jwt_secret=$(openssl rand -hex 32)
        echo "Generated random value for ADMIN_JWT_SECRET: $admin_jwt_secret"
    else
        admin_jwt_secret="${ADMIN_JWT_SECRET}"
    fi
    
    if [[ -z "${JWT_SECRET}" ]]; then
        jwt_secret=$(openssl rand -hex 32)
        echo "Generated random value for JWT_SECRET: $jwt_secret"
    else
        jwt_secret="${JWT_SECRET}"
    fi
    
    read -p "Enter the SMTP_HOST value (optional): " smtp_host
    
    read -p "Enter the SMTP_PORT value (optional): " smtp_port
    
    read -p "Enter the SMTP_SECURE value (optional): " smtp_secure
    
    read -p "Enter the SMTP_USER value (optional): " smtp_user
    
    read -p "Enter the SMTP_PASS value (optional): " smtp_pass
    
    read -p "Enter the FROM_EMAIL value (optional): " from_email
    
    read -p "Enter the FROM_NAME value (optional): " from_name
    
    # Create the .env file with the environment variables
    
cat > .env <<EOF
DATABASE_CLIENT=$db_client
DATABASE_HOST=$db_host
DATABASE_PORT=$db_port
DATABASE_NAME=$db_name
DATABASE_USERNAME=$db_username
DATABASE_PASSWORD=$db_password
DATABASE_SCHEMA=$db_schema
ADMIN_URL=$admin_url
PUBLIC_URL=$public_url
SERVER_HOST=$server_host
SERVER_PORT=$server_port
SERVER_PROXY=$server_proxy
NODE_ENV=$node_env
APP_KEYS=$app_keys
API_TOKEN_SALT=$api_token_salt
ADMIN_JWT_SECRET=$admin_jwt_secret
JWT_SECRET=$jwt_secret
SMTP_HOST=$smtp_host
SMTP_PORT=$smtp_port
SMTP_SECURE=$smtp_secure
SMTP_USER=$smtp_user
SMTP_PASS=$smtp_pass
FROM_EMAIL=$from_email
FROM_NAME=$from_name
EOF
    mv .env public_html
    echo "Strapi .env file created"
}

# Script to Clone Repository
clone_repository() {
    # Prompt the user for the repository URL
    read -p "Enter the repository URL: " repo_url
    
    # Clone the repository
    git clone $repo_url public_html
    
    echo "Repository cloned"
}

# Prompt the user for which script to run
echo "Which script would you like to run?"
echo "1. Generate RSA Key"
echo "2. Create Strapi .env File"
echo "3. Clone Repository"
read -p "Enter the number of the script: " script_num

# Run the selected script
case $script_num in
    1)
        generate_rsa_key
    ;;
    2)
        create_strapi_env_file
    ;;
    3)
        clone_repository
    ;;
    *)
        echo "Invalid script number"
        exit 1
    ;;
esac
