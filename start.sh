#!/bin/bash

# 1. Download Rclone Config (if link provided)
if [[ -n "$RCLONE_CONFIG_URL" ]]; then
    echo "Downloading rclone.conf..."
    wget -q "$RCLONE_CONFIG_URL" -O /usr/src/app/rclone.conf
fi

# 2. Download Token.pickle (if link provided)
if [[ -n "$TOKEN_PICKLE_URL" ]]; then
    echo "Downloading token.pickle..."
    wget -q "$TOKEN_PICKLE_URL" -O /usr/src/app/token.pickle
fi

# 3. Download Service Accounts (if link provided)
if [[ -n "$ACCOUNTS_ZIP_URL" ]]; then
    echo "Downloading accounts.zip..."
    wget -q "$ACCOUNTS_ZIP_URL" -O accounts.zip
    unzip -qo accounts.zip -d /usr/src/app/accounts
    rm accounts.zip
fi

# --- FIX FOR ARIA2RPC EXCEPTION ---
# Start Aria2c in background (Daemon mode) so the bot can connect to it
echo "Starting Aria2c..."
aria2c --enable-rpc --rpc-listen-all=false --rpc-listen-port=6800 \
       --max-connection-per-server=10 --rpc-max-request-size=1024M \
       --seed-time=0.01 --min-split-size=10M --follow-torrent=mem \
       --split=10 --daemon=true --allow-overwrite=true --user-agent=Wget/1.12
# ----------------------------------

# 4. Start the Bot
python3 -m bot
