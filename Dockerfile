# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables to prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Update package lists and install necessary system dependencies
# Includes Python 3.12 (default in Ubuntu 24.04), build tools, and media handlers
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    ffmpeg \
    mediainfo \
    build-essential \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libc-ares-dev \
    libcurl4-openssl-dev \
    libsodium-dev \
    libcrypto++-dev \
    libsqlite3-dev \
    libfreeimage-dev \
    swig \
    locales \
    curl \
    wget \
    p7zip-full \
    p7zip-rar \
    unzip \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy all repository files to the container
COPY . .

# Install Python dependencies from requirements.txt
# --break-system-packages is required on Ubuntu 24.04 to install via pip globally
RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages

# Default command to start the bot
# Runs update.py first (standard for WZML-X) then starts the bot module
CMD ["bash", "-c", "python3 update.py && python3 -m bot"]
