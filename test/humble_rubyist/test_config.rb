require 'test_helper'

class TestConfig < HRTest
  test "has dynamic accessors" do
    config = HumbleRubyist::Config.new do |c|
      c.foo = "bar"
    end
    assert_equal "bar", config.foo
  end
end
