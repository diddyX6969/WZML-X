# Use Ubuntu 24.04 (Noble Numbat) as the base image
FROM ubuntu:24.04

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Update apt and install essential build tools and dependencies
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
    python3.13 \
    python3.13-dev \
    python3.13-venv \
    python3.13-distutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up Python 3.13 as the default 'python3' and 'python'
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.13 1

# Install pip for Python 3.13
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.13

# Install rclone (required for cloud uploads)
RUN curl https://rclone.org/install.sh | bash

# Clone the repository (wzv3 branch)
RUN git clone -b wzv3(v1) https://https://github.com/diddyX6969/WZML-X.git /app

WORKDIR /usr/src/app
COPY . .
# This copies the 'bot' folder directly into /usr/src/app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Ensure the start script is executable
RUN chmod +x start.sh

# Start the bot
CMD ["bash", "start.sh"]
