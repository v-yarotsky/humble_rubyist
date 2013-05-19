require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'

$:.unshift File.expand_path("../../lib", __FILE__)
require 'humble_rubyist'

ENV["RACK_ENV"] = "test"

class HRTest < Minitest::Test
  def self.test(name, &block)
    raise ArgumentError, "Example name can't be empty" if String(name).empty?
    block ||= proc { skip "Not implemented yet" }
    define_method "test_#{name}", &block
  end

  def self.xtest(*)
  end
end

