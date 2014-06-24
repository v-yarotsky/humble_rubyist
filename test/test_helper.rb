require "bundler/setup"
require "minitest/autorun"

lib = File.expand_path("../../lib", __FILE__)
$:.unshift lib

ENV["RACK_ENV"] = "test"

if ENV["COVERAGE"]
  require "simplecov"
  if ENV["TRAVIS"]
    require "coveralls"
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  end
  SimpleCov.start do
    add_filter "/test/"
  end
  require "humble_rubyist"
  Bundler.require(:default, HumbleRubyist.environment)
  Dir.glob(File.join(lib, "**", "*.rb")).each { |f| require f }
end

require "humble_rubyist"

class HRTest < Minitest::Test
  def self.test(name, &block)
    raise ArgumentError, "Example name can't be empty" if String(name).empty?
    block ||= proc { skip "Not implemented yet" }
    define_method "test_#{name}", &block
  end

  def self.xtest(*)
  end

  def teardown_database
    session = Mongoid.session("default")
    session['system.namespaces'].find(:name => { '$not' => /system|\$/ }).to_a.each do |collection|
      _, collection_name = collection['name'].split('.', 2)
      session[collection_name].find.remove_all
    end
  end

  def assert_raises(*exception_klasses, &block)
    block.call
  rescue *exception_klasses => e
    true
  end
end
