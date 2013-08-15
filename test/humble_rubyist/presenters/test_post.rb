require "test_helper"
require "date"

class TestPostPresenter < HRTest
  class DummyPost
    attr_accessor :title, :published_at, :category, :slug
  end

  def setup
    @dummy_post = DummyPost.new.tap do |p|
      p.title = "test"
      p.published_at = Date.parse("2013-01-01 20:00:00")
      p.category = "category"
      p.slug = "test-slug"
    end

    super
  end

  test "delegates :title, :category to Post" do
    assert_equal "test", presenter(@dummy_post).title
    assert_equal "category", presenter(@dummy_post).category
  end

  test "#published_at formats date" do
    assert_equal "Jan 01, 2013", presenter(@dummy_post).published_at
  end

  test "#iso_published_at formats in ISO format" do
    assert_equal "2013-01-01", presenter(@dummy_post).iso_published_at
  end

  test "#permalink consists of date in ISO format and Post#slug" do
    assert_equal "/2013-01-01-test-slug", presenter(@dummy_post).permalink
  end

  test "#content renders post content for HTML" do
    renderer = Object.new
    def renderer.render(post); "rendered"; end
    assert_equal "rendered", presenter(@dummy_post, renderer).content
  end

  private

  def presenter(*args)
    HumbleRubyist::Presenters::Post.new(*args)
  end
end

