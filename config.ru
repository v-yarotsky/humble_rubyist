$:.unshift File.expand_path("../lib/", __FILE__)

require 'webrick'

WEBrick::Config::General[:DoNotReverseLookup] = true

require "humble_rubyist/application"

run HumbleRubyist::Application

