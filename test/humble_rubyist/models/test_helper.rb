require "test_helper"

class HRModelTest < HRTest
  include HumbleRubyist::Models

  def teardown
    Mongoid.session("default").drop
  end
end

