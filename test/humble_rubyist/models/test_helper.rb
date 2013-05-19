require 'test_helper'

class HRModelTest < HRTest
  include HumbleRubyist::Persistence
  include HumbleRubyist::Models

  HumbleRubyist::Persistence.ensure_schema!

  def teardown
    [:posts].each { |t| db.from(t).truncate }
  end
end


