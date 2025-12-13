# Use the Official Prebuilt Image
FROM anasty17/mltb:latest

# Set the working directory
WORKDIR /usr/src/app

# Copy your code into the container
COPY . .

# --- FIX FOR "STORMTORRENT" ERROR ---
# Creates a fake stormtorrent that points to the real qbittorrent-nox
RUN ln -sf /usr/bin/qbittorrent-nox /usr/bin/stormtorrent

# --- FIX FOR "EXTERNALLY MANAGED ENVIRONMENT" ---
# Added --break-system-packages to force the install
RUN pip install --no-cache-dir --break-system-packages -r requirements.txt

# Give permission to run scripts
RUN chmod +x start.sh

# Start the bot
CMD ["bash", "start.sh"]
