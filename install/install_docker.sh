#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

## | -------------- remove old version of docker -------------- |

sudo apt-get -y remove docker docker-engine docker.io containerd runc || echo "No old docker to uninstall"

## | -------------------- pre-install setup ------------------- |

sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

## | ---------------- download dockers gpg key ---------------- |

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

## | ----------------- setup stable repository ---------------- |

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## | ------------------ install docker engine ----------------- |

sudo apt-get -y update
sudo apt-get install docker-ce docker-ce-cli containerd.io
