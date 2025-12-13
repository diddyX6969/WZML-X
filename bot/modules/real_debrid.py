import requests
import re
from bot import LOGGER, config_dict
from bot.helper.ext_utils.bot_utils import new_task
from bot.helper.telegram_helper.message_utils import sendMessage, deleteMessage
from bot.helper.mirror_utils.download_utils.aria2_download import add_aria2c_download
from bot.helper.listeners.tasks_listener import MirrorLeechListener
from bot.helper.telegram_helper.filters import CustomFilters
from pyrogram import Client, filters

# -------------------------------------------------------------------------------------------------
# Real-Debrid Helper Functions
# -------------------------------------------------------------------------------------------------

def is_valid_url(url):
    """Simple regex to check if string looks like a URL."""
    regex = re.compile(
        r'^(?:http|ftp)s?://' # http:// or https://
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' # domain...
        r'localhost|' # localhost...
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' # ...or ip
        r'(?::\d+)?' # optional port
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)
    return re.match(regex, url) is not None

def unrestrict_link(link):
    """
    Unrestricts a Real-Debrid link using the API token from config.
    """
    rd_api = config_dict.get('REAL_DEBRID_API')
    if not rd_api:
        LOGGER.error("Real-Debrid API Token not found in config.env")
        return None, "API Token missing in config.env"

    url = "https://api.real-debrid.com/rest/1.0/unrestrict/link"
    data = {'auth_token': rd_api, 'link': link}
    
    try:
        response = requests.post(url, data=data)
        if response.status_code == 200:
            json_data = response.json()
            return json_data.get('download'), None
        elif response.status_code == 401:
            return None, "Invalid API Token or Account Expired."
        elif response.status_code == 503:
            return None, "Service Unavailable."
        else:
            return None, f"Error: {response.status_code} - {response.json().get('error', 'Unknown Error')}"
    except Exception as e:
        LOGGER.error(f"RD Unrestrict Error: {str(e)}")
        return None, str(e)

def _get_link_from_message(message):
    """Extracts link from message text or reply."""
    link = None
    # Check if command has an argument
    if len(message.command) > 1:
        link = message.command[1]
    # Check if replying to a message with a link
    elif message.reply_to_message:
        if len(message.reply_to_message.command) > 0:
             link = message.reply_to_message.command[0] # In case they reply to a link message
        else:
             link = message.reply_to_message.text
             
    return link.strip() if link else None

# -------------------------------------------------------------------------------------------------
# Command Handlers
# -------------------------------------------------------------------------------------------------

@Client.on_message(filters.command(['rdl', 'rl']) & CustomFilters.authorized)
@new_task
async def real_debrid_handler(client, message):
    """
    Handles /rdl (Mirror) and /rl (Leech) commands.
    """
    # 1. Get Link
    link = _get_link_from_message(message)

    # 2. Validate Link
    # If no link found OR link is not a valid URL structure
    if not link or not is_valid_url(link):
        await sendMessage("Enter Valid Link", message)
        return

    # 3. Determine Mode (Mirror vs Leech)
    cmd = message.command[0]
    is_leech = (cmd == 'rl')
    mode = "Leech" if is_leech else "Mirror"

    # 4. Notify User Processing Started
    msg = await sendMessage(f"<b>Processing {mode} request for Real-Debrid...</b>", message)

    # 5. Unrestrict Link via Real-Debrid API
    direct_link, error = unrestrict_link(link)
    
    if not direct_link:
        await msg.edit(f"<b>Real-Debrid Error:</b>\n{error}")
        return

    # 6. Start Aria2c Download
    # Initialize the Listener 
    listener = MirrorLeechListener(message, isZip=False, extract=False, isQbit=False, isLeech=is_leech)
    
    try:
        LOGGER.info(f"Adding RD link to Aria2: {direct_link}")
        # Note: DOWNLOAD_DIR is fetched from config, usually /usr/src/app/downloads/
        path = f"{config_dict.get('DOWNLOAD_DIR', '/usr/src/app/downloads/')}{message.id}"
        
        await add_aria2c_download(direct_link, path, listener, "")
        await deleteMessage(msg)
    except Exception as e:
        LOGGER.error(f"Failed to start Aria2 download: {e}")
        await msg.edit(f"<b>Failed to start download:</b>\n{e}")
