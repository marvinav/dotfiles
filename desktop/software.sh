#!/bin/bash

set -e
set -u
set -o pipefail

is_app_installed() {
  type "$1" &>/dev/null
}

# ####################################################################### #
# WSL installation                                                        #
# ####################################################################### #
keepassxc_install() {
  echo "Keepassxc installation"
  if is_app_installed yandex-disk; then
    printf "WARNING: \"keepassxc\" already installed.
Remove it first"
    exit 1
  fi
  add-apt-repository ppa:phoerious/keepassxc
  apt update
  apt install keepassxc
  echo "Keepassxc Installation completed"
}
# ####################################################################### #
# Yandex Disk Installation                                                #
# ####################################################################### #
yd_install(){
  echo "YD installation"
  if is_app_installed yandex-disk; then
    printf "WARNING: \"yandex-disk\" already installed.
Remove it first"
    exit 1
  fi
  wget https://repo.yandex.ru/yandex-disk/yandex-disk_latest_amd64.deb -o /tmp/yandex.deb
  apt install /tmp/yandex.deb
  rm /tmp/yandex.deb
  echo "YD Installation completed"
}
#################################################################
# Arguments parser 						#
#################################################################
while getopts aky opts;
do
  case $opts in
    a) keepassxc_install
      yd_install
      exit 0;;
    k) keepassxc_install;;
    y) yd_install;;
    ?) printf "Please, provide selected config\n"
      exit 1;;
  esac
done
