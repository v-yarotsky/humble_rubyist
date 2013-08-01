require "test_helper"
require "ostruct"

class TestMarkdownPostRenderer < HRTest
  test "simply renders Post to HTML" do
    p = post("ohai")
    assert_equal "<p>ohai</p>\n", HumbleRubyist::MarkdownPostRenderer.new.render(p)
  end

  test "renders Post until <!--more --> if cut mode enabled" do
    p = post(<<-POST)
Hello
<!-- more -->
Bye
    POST
    assert_equal "<p>Hello</p>\n", HumbleRubyist::MarkdownPostRenderer.new(cut: true).render(p)
  end

  private

  def post(content)
    post = OpenStruct.new.tap { |p| p.content = content }
  end
end

