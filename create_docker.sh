#!/bin/bash

if ! command -v docker &>/dev/null; then
    >&2 echo "Docker is not installed"
    exit 1
fi

if ! groups | grep '\bdocker\b' --only-matching &>/dev/null ; then 
    >&2 echo "Current user is not member of docker group"
    exit 2
fi

docker build \
    --rm \
    --tag=rust_nvim_docker \
    .

echo -e "\n\n\n\n\n"
echo "container rust_nvim_docker created, you can do :"
echo " * docker run -d -e HOST_USER_UID=\$(id -u)  --name YOUR_PROJECT -p YOUR_LOCAL_PORT:22 rust_nvim_docker => if you need one env by project"
echo -e "\n\n\n\n\n"
