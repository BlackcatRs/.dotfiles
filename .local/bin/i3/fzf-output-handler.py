#!/usr/bin/env python3
import subprocess, sys, os, os.path

path = sys.argv[1].strip()
cmdline = [ ]

if os.path.isdir(path):
    # If a directory is selected, launch a new terminal window with that directory as the working dir
    cmdline = ['/usr/bin/alacritty', '--working-directory', path]
else:
    # Decided what to do with a regular file based on its mime type
    mimetype = os.popen(f"xdg-mime query filetype {path}", "r").read().strip()
    
    if mimetype == "text/plain":
        # Open plain text files in a new terminal with neovim
       cmdline = ["emacsclient", "-c", "-a", "emacs", path]
    else:
        # Launch with default applications for all other types.
        cmdline = ["/usr/bin/xdg-open", path]

subprocess.Popen(cmdline)
