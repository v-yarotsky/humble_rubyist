require "humble_rubyist/models/test_helper"

class PostTest < HRModelTest
  test ".find_by_date_and_slug returns a corresponding post" do
    p1 = insert_post(published_at: Date.parse("2013-01-01"), slug: "find-me")
    p2 = insert_post(published_at: Date.parse("2013-01-01"), slug: "dont-find-me")
    assert_equal p1, Post.find_by_date_and_slug(Date.parse("2013-01-01"), "find-me")
  end

  test ".ordered_by_date returns all posts starting with newest" do
    p1 = build_post(published_at: Date.parse("2013-01-05"))
    p2 = build_post(published_at: Date.parse("2013-01-20"))
    p3 = build_post(published_at: Date.parse("2013-01-01"))
    assert_equal [p2, p1, p3], Post.ordered_by_date([p1, p2, p3])
  end

  test ".published returns only published posts" do
    p1 = build_post(published_at: Date.today)
    p2 = build_post(published_at: nil)
    assert_equal [p1], Post.published([p1, p2])
  end

  test "is created with valid attributes" do
    assert create_post(title: "Post 1", slug: "post-1", content: "Ohai"), "expected Post to be created"
  end

  test "can not be created without a title" do
    assert_raises(ValidationError) { create_post(slug: "post-1", content: "Ohai") }
  end

  test "can not be created without a slug" do
    assert_raises(ValidationError) { create_post(title: "Post 1", content: "Ohai") }
  end

  test "can not be created without content" do
    assert_raises(ValidationError) { create_post(title: "Post 1", slug: "post-1") }
  end

  test "can not be updated without a title" do
    post = create_valid_post
    assert_raises(ValidationError) { post.update!(title: "") }
  end

  test "can not be updated without a slug" do
    post = create_valid_post
    assert_raises(ValidationError) { post.update!(slug: "") }
  end

  test "can not be updated without content" do
    post = create_valid_post
    assert_raises(ValidationError) { post.update!(content: "") }
  end

  def insert_post(attributes = {})
    build_post(attributes).tap { |p| p.save!(validate: false) }
  end

  def build_post(attributes = {})
    Post.new(attributes)
  end

  def create_post(attributes = {})
    Post.create!(attributes)
  end

  def create_valid_post
    create_post(title: "Post 1", slug: "post-1", content: "Ohai")
  end
end
