require 'test_helper'

class HRModelTest < HRTest
  require 'humble_rubyist/persistence'
  require 'humble_rubyist/models'

  include HumbleRubyist::Persistence
  include HumbleRubyist::Models

  HumbleRubyist::Persistence.ensure_schema!

  def teardown
    [:posts].each { |t| db.from(t).truncate }
  end
end


