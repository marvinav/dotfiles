#!/bin/bash

# Requirements:
# Xorg.11
# End of Requirements.

# Check if gnome application is open.
# If open, when bring window to focus and current workspace.
SERVICE='gnome-terminal'

if ! wmctrl -xR $SERVICE
then
  $SERVICE
fi
