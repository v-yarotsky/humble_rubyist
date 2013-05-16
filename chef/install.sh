#!/bin/bash

chef_binary=/usr/local/lib/ruby/gems/1.9.1/gems/chef-11.4.4/bin/chef-solo

"$chef_binary" -c solo.rb
