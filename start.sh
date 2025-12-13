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

# 4. Start the Bot (Running directly without .venv)
python3 -m bot
