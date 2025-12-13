from .bot_settings import send_bot_settings, edit_bot_settings
from .cancel_task import cancel, cancel_multi, cancel_all_buttons, cancel_all_update
from .chat_permission import authorize, unauthorize, add_sudo, remove_sudo
from .clone import clone_node
from .exec import aioexecute, execute, clear
from .file_selector import select, confirm_selection
from .force_start import remove_from_queue
from .gd_count import count_node
from .gd_delete import delete_file
from .gd_search import gdrive_search, select_type
from .help import arg_usage, bot_help
from .mediainfo import mediainfo
from .broadcast import broadcast
from .uphoster import uphoster
from .mirror_leech import (
    mirror,
    leech,
    qb_leech,
    qb_mirror,
    jd_leech,
    jd_mirror,
    nzb_leech,
    nzb_mirror,
)
from .restart import (
    restart_bot,
    restart_notification,
    confirm_restart,
    restart_sessions,
)
from .imdb import imdb_search, imdb_callback
from .rss import get_rss_menu, rss_listener
from .search import torrent_search, torrent_search_update, initiate_search_tools
from .nzb_search import hydra_search
from .services import start, start_cb, login, ping, log, log_cb
from .shell import run_shell
from .stats import bot_stats, stats_pages, get_packages_version
from .status import task_status, status_pages
from .users_settings import get_users_settings, edit_user_settings, send_user_settings
from .ytdlp import ytdl, ytdl_leech

from os.path import dirname, basename, isfile
import glob

# This finds all .py files in the modules folder
modules = glob.glob(dirname(__file__) + "/*.py")

# This creates a list of all module names (excluding __init__.py)
__all__ = [ basename(f)[:-3] for f in modules if isfile(f) and not f.endswith('__init__.py')]
