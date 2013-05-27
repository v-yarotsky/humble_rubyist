require 'humble_rubyist/models/test_helper'

class PostTest < HRModelTest
  test ".find_by_date_and_slug returns a corresponding post" do
    p1 = Post.insert(published_at: Date.parse("2013-01-01"), slug: "find-me")
    p2 = Post.insert(published_at: Date.parse("2013-01-01"), slug: "dont-find-me")
    assert_equal p1, Post.find_by_date_and_slug(Date.parse("2013-01-01"), "find-me").id
  end

  test ".ordered_by_date returns all posts starting with newest" do
    p1 = Post.insert(published_at: Date.parse("2013-01-05"))
    p2 = Post.insert(published_at: Date.parse("2013-01-20"))
    p3 = Post.insert(published_at: Date.parse("2013-01-01"))
    assert_equal [p2, p1, p3], Post.ordered_by_date.map(&:id)
  end

  test "is created with valid attributes" do
    assert Post.create(title: "Post 1", slug: "post-1", content: "Ohai"), "expected Post to be created"
  end

  test "can not be created without a title" do
    assert_raises(ValidationError) { Post.create(slug: "post-1", content: "Ohai") }
  end

  test "can not be created without a slug" do
    assert_raises(ValidationError) { Post.create(title: "Post 1", content: "Ohai") }
  end

  test "can not be created without content" do
    assert_raises(ValidationError) { Post.create(title: "Post 1", slug: "post-1") }
  end
end
