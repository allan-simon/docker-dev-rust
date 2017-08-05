## Devbox for rust projects using docker

[![Docker Automated buil](https://img.shields.io/docker/automated/allansimon/docker-dev-rust.svg)]()
[![Docker Build Statu](https://img.shields.io/docker/build/allansimon/docker-dev-rust.svg)]()

### What you will get at the end

   * a docker container in which you can SSH in
   * (optional) neovim: with deoplete , and rust language server
   * (optional) Zsh: with my zshrc (that you can replace by yours)

### Requirements

   * docker

### Creation

```bash
./create_docker.sh
```

### Usage

```bash
docker run -d -e HOST_USER_UID=$(id -u)  --name YOUR_PROJECT -p YOUR_LOCAL_PORT:22 rust_nvim_docker
```

so then you can `ssh` in your machine with port `YOUR_LOCAL_PORT`

or you can use it in a Vagrantfile like this 

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2 expandtab :

PROJECT = "your_project"

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'
Vagrant.configure(2) do |config|

  config.ssh.insert_key = false
  config.vm.define "dev", primary: true do |app|
    app.vm.provider "docker" do |d|
      d.image = "allansimon/docker-dev-rust"
      d.name = "#{PROJECT}_dev"
      d.has_ssh = true
      d.env = {
        "HOST_USER_UID" => Process.euid,
      }
    end
    app.ssh.username = "vagrant"
  end
end
```

to have a light and isolated dev environment

### Extensive list of stuff installed:

  - neovim
  - zsh
  - rust
