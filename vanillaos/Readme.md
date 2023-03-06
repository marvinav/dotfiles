My scripts for VanillaOS.

# Development

## Requirements:
1. Flatpack vscode
```sh
flatpack install com.visualstudio.code
```
2. slirp4netns
```sh
apx init --nix
apx install --nix slirp4netns
```
apx init --nix
apx install --nix slirp4netns

## Use

1. Build image
```sh
podman build -f Dockerfile.dev -t dpodfordev
```
2. Start container
```sh
podman run -ti -p 10022:22 -v /home/marvinav/Source:/home/developer/Source localhost/dpodfordev:latest
```