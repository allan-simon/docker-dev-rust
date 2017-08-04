## Devbox for python projects using docker

### What you will get at the end

   * a docker container in which you can SSH in
   * (optional) neovim: with neomake , and rust language server
   * (optional) Zsh: with my zshrc (that you can replace by yours)

### Requirements

   * docker

### Creation

```bash
./create_docker.sh
```

### Usage

```bash
docker run -d -e HOST_USER_UID=$(id -u)  --name YOUR_PROJECT -p YOUR_LOCAL_PORT:22 js_vim_docker
```

so then you can `ssh` in your machine with port `YOUR_LOCAL_PORT`

### Extensive list of stuff installed:

TODO
