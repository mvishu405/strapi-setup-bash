#!/usr/bin/env bash

set -euo pipefail

# === Prompt for credentials ===
read -rp "Enter MySQL Host [default: localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -rp "Enter MySQL Port [default: 3306]: " DB_PORT
DB_PORT=${DB_PORT:-3306}

read -rp "Enter MySQL Username: " DB_USER
read -srp "Enter MySQL Password: " DB_PASS
echo
read -rp "Enter Database Name: " DB_NAME

# === Dump Configuration ===
DUMP_DIR="./db_backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DUMP_FILE="$DUMP_DIR/${DB_NAME}_backup_$TIMESTAMP.sql"

# Create output directory if it doesn't exist
mkdir -p "$DUMP_DIR"

echo "[INFO] Dumping database '$DB_NAME' to '$DUMP_FILE'..."

# Perform the dump
mysqldump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$DUMP_FILE"

echo "[✅] Dump completed: $DUMP_FILE"
