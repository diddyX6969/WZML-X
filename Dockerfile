FROM ubuntu:22.04

# Fix non-interactive installation
ARG DEBIAN_FRONTEND=noninteractive

# Set the working directory
WORKDIR /usr/src/app

# Install dependencies and standard qbittorrent
RUN apt-get update && apt-get install -y \
    software-properties-common \
    git \
    wget \
    curl \
    pv \
    jq \
    ffmpeg \
    aria2 \
    qbittorrent-nox \
    p7zip-full \
    libcurl4-openssl-dev \
    libssl-dev \
    libc-ares-dev \
    libsodium-dev \
    libcrypto++-dev \
    libsqlite3-dev \
    libfreeimage-dev \
    locales \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Fix Python Symlinks
RUN ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    ln -sf /usr/bin/python3.11 /usr/bin/python

# Copy requirements and install them
COPY requirements.txt .
RUN python3 -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# --- FIX FOR MISSING STORMTORRENT ---
# This creates a link: When bot calls 'stormtorrent', it runs 'qbittorrent-nox' instead.
RUN ln -sf /usr/bin/qbittorrent-nox /usr/src/app/stormtorrent
# ------------------------------------

# Set Permissions
RUN chmod -R 777 /usr/src/app

# Start the bot
CMD ["bash", "start.sh"]
