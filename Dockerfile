# Use the Official Prebuilt Image (Contains all dependencies pre-installed)
FROM anasty17/mltb:latest

# Set the working directory
WORKDIR /usr/src/app

# Copy your code into the container
COPY . .

# --- FIX FOR "STORMTORRENT" ERROR ---
# This creates a "fake" stormtorrent that points to the real qbittorrent
# This tricks your bot into thinking stormtorrent exists.
RUN ln -sf /usr/bin/qbittorrent-nox /usr/bin/stormtorrent
# ------------------------------------

# Install Python Requirements
# (We use --ignore-installed to prevent conflicts with pre-installed packages)
RUN pip install --no-cache-dir --ignore-installed -r requirements.txt

# Give permission to run scripts
RUN chmod +x start.sh

# Start the bot
CMD ["bash", "start.sh"]
