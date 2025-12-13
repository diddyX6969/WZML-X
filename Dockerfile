FROM ubuntu:22.04

# Fix non-interactive installation
ARG DEBIAN_FRONTEND=noninteractive

# Set the working directory
WORKDIR /usr/src/app

# Install dependencies and Python 3.11 (Most stable for this bot)
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
    # removed python3-distutils because it is built-in or unnecessary for 3.11+
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up Python environment
ENV PYTHONUNBUFFERED=1
RUN ln -s /usr/bin/python3.11 /usr/bin/python3 && \
    ln -s /usr/bin/python3.11 /usr/bin/python

# Copy requirements and install them
COPY requirements.txt .
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Set permissions for the start script
RUN chmod +x start.sh

# Start the bot
CMD ["bash", "start.sh"]
