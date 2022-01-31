SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

DOTFILES_ROOT=$1

#############################################
# Colors                                    #
#############################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

red() {
    printf "${RED}$@${NC}\n"
}

green() {
    printf "${GREEN}$@${NC}\n"
}

yellow() {
    printf "${YELLOW}$@${NC}\n"
}

#############################################
# Helpers                                   #
#############################################

is_app_installed() {
  type "$1" &>/dev/null
}

#############################################
# Main                                      #
#############################################

if [ ! -z "$SUDO_USER" ]
then 
    HOME_DIR="$(eval echo ~$SUDO_USER)"
else
    echo "$(red "Error! Should be run as sudo")"
    exit 1
    HOME_DIR="$(eval echo ~$USER)"
fi

if [ -z "$DOTFILES_ROOT" ]
then
    DOTFILES_ROOT="$HOME_DIR/.dotfiles"
fi

echo "Dotfiles will be cloned to $(green $DOTFILES_ROOT)"

if ! is_app_installed git; then
    echo "git not found. Try install it."
    apt-get install -y git
fi

git clone https://github.com/marvinav/dotfiles $1

echo "Requirements installation in progress"
source $DOTFILES_ROOT/requrements.sh
echo "Install security policy"
source $DOTFILES_ROOT/server/setup.sh
echo "Install shell, tmux and other utilities"
source $DOTFILES_ROOT/install.sh -d