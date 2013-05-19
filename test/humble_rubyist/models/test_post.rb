require 'humble_rubyist/models/test_helper'

class PostTest < HRModelTest
  test ".find_by_date_and_slug returns a corresponding post" do
    p1 = Post.create(published_at: Date.parse("2013-01-01"), slug: "find-me")
    p2 = Post.create(published_at: Date.parse("2013-01-01"), slug: "dont-find-me")
    assert_equal p1, Post.find_by_date_and_slug(Date.parse("2013-01-01"), "find-me")
  end

  test ".ordered_by_date returns all posts starting with newest" do
    p1 = Post.create(published_at: Date.parse("2013-01-05"))
    p2 = Post.create(published_at: Date.parse("2013-01-20"))
    p3 = Post.create(published_at: Date.parse("2013-01-01"))
    assert_equal [p2, p1, p3], Post.ordered_by_date
  end
end
