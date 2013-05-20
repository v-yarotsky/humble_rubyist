require 'test_helper'
require 'humble_rubyist/application'
require 'capybara_minitest_spec'

require 'capybara/dsl'

class HRRequestTest < HRTest
  include Rack::Test::Methods
  include HumbleRubyist::Persistence
  include HumbleRubyist::Models
  include Capybara::DSL

  HumbleRubyist::Persistence.ensure_schema!

  Capybara.app = HumbleRubyist::Application

  def teardown
    [:posts].each { |t| db.from(t).truncate }
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

