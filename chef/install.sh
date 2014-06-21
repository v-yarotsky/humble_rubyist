#!/bin/bash

chef_binary=/usr/bin/chef-solo

if [ ! -x "$chef_binary" ]; then
  apt-get update
  apt-get install -y curl
  curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi

"$chef_binary" -c solo.rb
