#!/bin/bash

# Description
# Fix theming issue with qt apps in gtk enviroments

# Requirements
# Ubuntu 20.04 and above

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

apt install -y qt5-style-plugins appmenu-gtk2-module

cp "$SCRIPT_DIR/qt-gtk.conf" "/etc/environment.d/qt-gtk.conf"