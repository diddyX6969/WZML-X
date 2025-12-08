# Use Python 3.10 on Debian Buster slim image
FROM python:3.10-slim-buster

# Set environment variables to prevent interactive prompts during installs
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install system dependencies required by WZML-X
# (ffmpeg, aria2, p7zip, curl, git, etc.)
RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    aria2 \
    wget \
    curl \
    pv \
    jq \
    tar \
    xz-utils \
    p7zip-full \
    unzip \
    libcurl4-openssl-dev \
    libssl-dev \
    locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Rclone (Latest Version)
# WZML-X uses rclone for cloud uploads
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    cp rclone-*-linux-amd64/rclone /usr/bin/ && \
    chown root:root /usr/bin/rclone && \
    chmod 755 /usr/bin/rclone && \
    rm -rf rclone-*

# 3. Set the working directory
WORKDIR /usr/src/app

# 4. Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# 5. Copy the rest of the application code
COPY . .

# 6. Ensure the start script is executable
RUN chmod +x start.sh

# 7. Expose ports (Optional, but good practice for Railway's health checks)
# WZML-X usually runs a web server on port 80 or 8080 for status/token
EXPOSE 80 8080

# 8. Start the bot
CMD ["bash", "start.sh"]
