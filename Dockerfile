FROM ubuntu:22.04

# 1. Setup Environment
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /usr/src/app

# 2. Install System Dependencies (Using Default Python 3.10)
# We use the default python3 to avoid 'distutils' and version errors.
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 3. Fix "Stormtorrent" Error
# Creates a fake stormtorrent pointing to qbittorrent
RUN ln -sf /usr/bin/qbittorrent-nox /usr/bin/stormtorrent

# 4. Copy Code & Install Python Requirements
COPY . .
# We upgrade pip first, then install requirements with the break-flag to be safe
RUN python3 -m pip install --upgrade pip && \
    pip install --no-cache-dir --break-system-packages -r requirements.txt

# 5. Permission Fix
RUN chmod -R 777 /usr/src/app
RUN chmod +x start.sh

# 6. Start Command
CMD ["bash", "start.sh"]
