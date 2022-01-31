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
# ZSH installation                                                        #
# ####################################################################### #
zsh_install() {
  echo "ZSH installation"
  CURRENTSHELL=$(grep $USER /etc/passwd | cut -d ':' -f 7)
  if ! is_app_installed zsh; then
    printf "WARNING: \"zsh\" command is not found. \
      Install it first.\n"
          return
        elif [[ $CURRENTSHELL != "/bin/zsh" ]]; then
          chsh --shell /bin/zsh
  fi

  ln -sf "$REPODIR"/zsh/zshrc "$HOME"/.zshrc
  ln -sf "$REPODIR"/zsh/zshrc.local "$HOME"/.zshrc.local
  ln -sf "$REPODIR"/zsh "$HOME"/.zsh

  if ! is_app_installed trash-put; then
    printf "WARNING: \"trash-put\" command in not found. \
Install trash-cli first to use \"trash-put\" alias for \"rm\""
  fi

  if ! is_app_installed fdfind; then
    printf "WARNING: \"fdfind\" command in not found. \
Install fdfind first to use \"fdfind\" alias for \"fd\""
  fi
  if [ ! -e "$HOME/.zsh-nvm/zsh-nvm.plugin.zsh" ]; then
    printf "WARNING: Cannot found Zsh-nvm plugin \
at default location: \$HOME/.zsh-nvm. To use nvm install it first.\n"
  fi

  echo "ZSH installation completed"
}

# ####################################################################### #
# NVM installation (deprecated)                                           #
# ####################################################################### #
nvm_install(){
  echo "NVM installation"
  if [ -e "$HOME/.zsh-nvm/zsh-nvm.plugin.zsh" ]; then
    printf "WARNING: Zsh-nvm plugin already installed \
at default location: \$HOME/.zsh-nvm. Remove it first.\n"
  elif is_app_installed node; then
    printf "WARNING: \"node\" already installed. Remove it first.\n"
  else
    git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
  fi
  echo "NVM installation completed";
}

# ####################################################################### #
# n installation                                                        #
# ####################################################################### #
n_install(){
  echo "n installation"
  if [ -e "$HOME/.zsh-nvm/zsh-nvm.plugin.zsh" ]; then
    printf "WARNING: Zsh-nvm plugin already installed \
at default location: \$HOME/.zsh-nvm. Remove it first.\n"
  elif is_app_installed node; then
    printf "WARNING: \"node\" already installed. Remove it first.\n"
  elif [ -d "$HOME/.nvm" ]; then
    printf "WARNING: \"nvm\" already installed. Remove it first.\n"
  elif [ -d "$HOME/.n" ]; then
    printf "WARNING: \"n\" already installed. Remove it first.\n"
  else
    mkdir $HOME/.n
    export N_PREFIX=$HOME/.n
    PATH=$PATH:~/.n/bin
    curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
    bash n lts
    npm install -g n
    rm n
  fi
  echo "NVM installation completed";
}

# ####################################################################### #
# Vim Installation                                                        #
# ####################################################################### #
vim_install() {
  echo "Vim installation"
  if ! is_app_installed vim; then
    printf "WARNING: \"zsh\" command is not found. \
      Install it first\n"
          exit 1
  fi
  if [ -d "$HOME/.vim" ]; then
    printf "\"vim\" configuration already installed. Backup created."
    mv -f "$HOME/.vim" "$HOME/.vim.backup"
  fi
  ln -sf "$REPODIR"/vim "$HOME"/.vim
  ln -sf "$REPODIR"/vim/.vimrc "$HOME"/.vimrc

  echo "Download Vim Plugin Tool"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "Install Vim plugins"
  vim +PlugInstall +qall +q
  echo "Vim installation completed"
}
# ####################################################################### #
# Tmux                                                                    #
# ####################################################################### #
tmux_install() {
  echo "Tmux installation"
  if ! is_app_installed tmux; then
    printf "WARNING: \"tmux\" command is not found. \
      Install it first\n"
          exit 1
  fi

  if [ -e "$HOME/.tmux.conf" ]; then
    printf "Found existing .tmux.conf in your \$HOME directory. Will create a backup at $HOME/.tmux.conf.bak\n"
  fi

  ln -sf "$REPODIR"/tmux "$HOME"/.tmux
  ln -sf "$REPODIR"/tmux/tmux.conf "$HOME"/.tmux.conf;

  if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
    printf "WARNING: Cannot found TPM (Tmux Plugin Manager) \
      at default location: \$HOME/.tmux/plugins/tpm.\n"
          git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  # Install TPM plugins.
  # TPM requires running tmux server, as soon as `tmux start-server` does not work
  # create dump __noop session in detached mode, and kill it when plugins are installed
  printf "Install TPM plugins\n"
  tmux new -d -s __noop >/dev/null 2>&1 || true
  tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
  "$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
  tmux kill-session -t __noop >/dev/null 2>&1 || true

  echo "TMUX installation completed"
}
#################################################################
# Arguments parser 						#
#################################################################
while getopts dnztvo opts;
do
  case $opts in
    d) n_install 
      zsh_install
      tmux_install
      vim_install
      exit 0;;
    n) n_install;;
    z) zsh_install;;
    t) tmux_install;;
    v) vim_install;;
    ?) printf "Please, provide selected config\n"
      exit 1;;
  esac
done
