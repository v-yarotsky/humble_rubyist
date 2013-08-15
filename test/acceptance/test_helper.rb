require "test_helper"
require "humble_rubyist/application"
require "capybara_minitest_spec"

require "capybara/dsl"

class HRRequestTest < HRTest
  include Rack::Test::Methods
  include HumbleRubyist::Models
  include Capybara::DSL

  Capybara.app = HumbleRubyist::Application

  def app
    Capybara.app
  end

  def teardown
    Mongoid.session("default").drop
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def mu_pp(obj)
    if obj.is_a?(String) && %r{\A<!DOCTYPE html>} =~ obj
      "\n" + obj # don't use #inspect on HTML output
    else
      super
    end
  end
end

