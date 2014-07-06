require 'test_helper'
require 'humble_rubyist/armchair'

class TestConfig < HRTest
  include HumbleRubyist

  test "can register and inject dependencies" do
    n = 0
    Armchair.register_dependency :_will_never_clash do
      n += 1
    end

    assert_equal 1, Armchair.inject_dependency(:_will_never_clash)
    assert_equal 2, Armchair.inject_dependency(:_will_never_clash) # calls a block each time
  end
end
