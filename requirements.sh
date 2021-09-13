# Install Required Dependencies
echo 'Install required dependencies'
apt update
apt install htop tmux zsh vim git curl \
fd-find `#.gitignore friendly find alternative` \
ripgrep `#.gitignore friendly grep alternative` \
mc `#FAR-like explorer` \
nmon `#System Resource monitore utility` \
ncdu `#Disk usage analyzer` \
elinks `#TUI Browser` \
neofetch `#Info about distro` \
chafa caca-utils `#To Show image as ANSI sequence` \
trash-cli `#Cool wrapper for rm with restore function` \
jq `#JSON preprocessor` \
tldr `#Short description and most often usage of commands` \
net-tools 
