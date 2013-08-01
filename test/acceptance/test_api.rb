require "acceptance/test_helper"

class TestApi < HRRequestTest
  test "GET /api/posts renders json for all posts" do
    create_posts
    get "/api/posts"
    expected_response = {
      "posts" => [
        { "id" => Post.first.id }.merge(first_post_attributes),
        { "id" => Post.last.id  }.merge(second_post_attributes)
      ]
    }
    assert_equal expected_response, JSON.load(last_response.body)
  end

  test "GET /api/posts/:id renders json for particular post" do
    create_posts
    get "/api/posts/#{Post.first.id}"
    expected_response = { "id" => Post.first.id }.merge(first_post_attributes)
    assert_equal expected_response, JSON.load(last_response.body)
  end

  test "GET /api/posts/:id returns 404 if post is not found" do
    get "/api/posts/8848848"
    assert_equal 404, last_response.status
  end

  test "POST /api/posts creates a post" do
    post "/api/posts", first_post_attributes.to_json
    assert_equal 200, last_response.status
    assert_equal "Post1", Post.first.title
  end

  test "POST /api/posts doesn't create an invalid post and returns 400" do
    post "/api/posts", {}.to_json
    assert_equal 400, last_response.status
    assert_equal 0, Post.count
  end

  test "PUT /api/posts/:id updates post" do
    create_posts
    put "/api/posts/#{Post.first.id}", first_post_attributes.merge("title" => "Updated post 1").to_json
    assert_equal 200, last_response.status
    assert_equal "Updated post 1", Post.first.title
  end

  test "PUT /api/posts/:id does not update post with invalid attributes and returns 400" do
    create_posts
    put "/api/posts/#{Post.first.id}", first_post_attributes.merge("title" => nil).to_json
    assert_equal 400, last_response.status
    assert_equal "Post1", Post.first.title
  end

  test "PUT /api/posts/:id returns 404 if post does not exist" do
    put "/api/posts/984902", first_post_attributes.to_json
    assert_equal 404, last_response.status
  end

  private

  def create_posts
    Post.create(first_post_attributes)
    Post.create(second_post_attributes)
  end

  def first_post_attributes
    { "slug" => "post-1", "title" => "Post1", "content" => "Test post 1\n<!-- more -->\nUndercut1", "published_at" => "2013-01-02 00:00:00 UTC", "icon" => nil, "published" => true }
  end

  def second_post_attributes
    { "slug" => "post-2", "title" => "Post2", "content" => "Test post 2\n<!-- more -->\nUndercut2", "published_at" => "2013-01-03 00:00:00 UTC", "icon" => nil, "published" => true }
  end
end


