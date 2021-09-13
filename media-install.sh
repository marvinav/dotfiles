#!/bin/bash

set -e
set -u
set -o pipefail

is_app_installed() {
  type "$1" &>/dev/null
}

REPODIR="$(cd "$(dirname "$0")"; pwd -P)"
cd "$REPODIR";

# ####################################################################### #
# WSL installation                                                        #
# ####################################################################### #
wsl_install() {
  echo "WSL installation"
  if ! is_app_installed socat; then
    printf "WARNING: \"socat\" is not found. \
     Install it first\n"
    exit 1
  fi
  wget --output-document /tmp/npiperelay.zip https://github.com/jstarks/npiperelay/releases/latest/download/npiperelay_windows_amd64.zip
  unzip /tmp/npiperelay.zip -d "${HOME}/npiperelay"
  cp "./wsl/zshrc.wsl.local" "${HOME}/.zsh/zshrc.d/zshrc.wsl.local"
  ## cp "./wsl/pulseaudio-daemon.sh" "${HOME}/.zsh/pulseaudio-daemon.sh"
  echo "WSL installation completed."
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
  wget https://repo.yandex.ru/yandex-disk/yandex-disk_latest_amd64.deb
  apt install ./yandex-disk_latest_amd64.deb
  rm ./yandex-disk_latest_amd64.*
  echo "YD Installation completed"
}
#################################################################
# Arguments parser 						#
#################################################################
while getopts awy opts;
do
  case $opts in
    a) wsl_install
      exit 0;;
    w) wsl_install;;
    y) yd_install;;
    ?) printf "Please, provide selected config\n"
      exit 1;;
  esac
done
