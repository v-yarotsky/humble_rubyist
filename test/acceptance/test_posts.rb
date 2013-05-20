require 'acceptance/test_helper'

class TestPosts < HRRequestTest
  test "GET / renders layout" do
    visit "/"
    assert_page_has_title page, "Humble Rubyist"
  end

  test "GET / renders posts until cut" do
    create_posts
    visit "/"
    assert_page_has_content page, "Test post 2"
    refute_page_has_content page, "Undercut2"
  end

  test "GET / renders posts with links to full versions" do
    create_posts
    visit "/"
    assert_page_has_link page, "Read on", href: "/2013-01-02-post-1"
  end

  test "GET / renders posts reversively ordered by publishing date" do
    create_posts
    visit "/"
    assert_match /Post2.*Post1/m, page.body
  end

  test "GET /<permalink> renders full post" do
    create_posts
    visit "/2013-01-03-post-2"
    assert_page_has_content page, "Undercut2"
  end

  private

  def create_posts
    Post.create(title: "Post1", slug: "post-1", published_at: Date.parse("2013-01-02"), content: "Test post 1\n<!-- more -->\nUndercut1")
    Post.create(title: "Post2", slug: "post-2", published_at: Date.parse("2013-01-03"), content: "Test post 2\n<!-- more -->\nUndercut2")
  end
end

