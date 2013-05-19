require 'test_helper'

class GravatarTest < HRTest
  class Dummy
    include HumbleRubyist::Helpers::Gravatar
  end

  test "returns urls for correct sizes" do
    assert_match /\Ahttp.*?s=64\Z/, Dummy.new.gravatar(:medium).to_s
    assert_match /\Ahttp.*?s=16\Z/, Dummy.new.gravatar(:favicon).to_s
  end
end

