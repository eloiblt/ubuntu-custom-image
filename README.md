Custom ubuntu docker image with zsh, powerlevel10k and ttyd

```sh
docker build -t ghcr.io/eloiblt/ubuntu-custom-image --progress=plain  . 
docker run -it -p 2222:22 -p 7681:7681 ghcr.io/eloiblt/ubuntu-custom-image
```