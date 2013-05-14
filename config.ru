lib = File.expand_path("../lib/", __FILE__)
$:.unshift lib

require "humble_rubyist/application"

run HumbleRubyist::Application

