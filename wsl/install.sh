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