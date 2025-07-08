sudo apt update
sudo apt install expect -y

----------------------------------


#!/usr/bin/env bash

set -e  # Exit on any error

# Credentials (or load from environment)
GIT_USERNAME="${GIT_USERNAME:-developer@ting.in}"
GIT_PASSWORD="${GIT_PASSWORD:-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}"

# Perform git pull using expect
expect <<EOF
log_user 1
set timeout 20
spawn git pull

expect {
    "Username*" {
        send "$GIT_USERNAME\r"
        exp_continue
    }
    "Password*" {
        send "$GIT_PASSWORD\r"
        exp_continue
    }
    "Please enter a commit message" {
        # Send a default commit message and save+exit
        send "Auto-merge by script\r"
        send "\x1B:wq\r"
        exp_continue
    }
    eof
}
EOF

echo "[INFO] Git pull completed."

# Run your build commands
echo "[INFO] Running npm install..."
npm install

echo "[INFO] Running npm build..."
npm run build

echo "[INFO] Restarting PM2..."
pm2 restart all

echo "[INFO] ✅ Script completed."



--------------------------------------------------
chmod u+x deploy.sh
