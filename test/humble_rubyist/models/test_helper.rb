require "test_helper"

class HRModelTest < HRTest
  include HumbleRubyist::Models

  def teardown
    teardown_database
  end
end

