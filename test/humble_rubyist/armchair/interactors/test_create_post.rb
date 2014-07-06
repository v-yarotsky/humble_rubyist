require 'test_helper'

class TestCreatePost < ArmchairTest
  def valid_post_attributes
    {
      id: "the-post",
      title: "the post",
      category: "ruby",
      content: "Here be post"
    }
  end

  def repository
    @repository ||= TestPostRepo.new
  end

  def setup
    @repository = nil
    HumbleRubyist::Armchair.register_dependency(:posts_repository) { repository }
  end

  test "responds with serialized post for valid post" do
    creator = Interactors::CreatePost.new(valid_post_attributes)
    response = creator.perform

    assert_equal(valid_post_attributes, response.body)
    assert_equal({}, response.error)
  end

  test "persists the post" do
    creator = Interactors::CreatePost.new(valid_post_attributes)

    creator.perform
    assert_equal([Entities::Post.new(valid_post_attributes)], repository.to_a)
  end

  test "responds with normalized post attributes for invalid post" do
    creator = Interactors::CreatePost.new({})
    response = creator.perform

    assert_equal({ id: "", title: "", category: "", content: "" }, response.body)
  end

  test "empty title" do
    [nil, ""].each do |invalid_title|
      creator = Interactors::CreatePost.new(title: invalid_title)
      response = creator.perform

      assert_equal(["must not be empty"], response.error[:title])
    end
  end

  test "empty category" do
    [nil, ""].each do |invalid_category|
      creator = Interactors::CreatePost.new(category: invalid_category)
      response = creator.perform

      assert_equal(["must not be empty"], response.error[:category])
    end
  end

  test "empty id" do
    [nil, ""].each do |invalid_id|
      creator = Interactors::CreatePost.new(id: invalid_id)
      response = creator.perform

      assert_equal(["must not be empty"], response.error[:id])
    end
  end

  test "duplicate id" do
    creator = Interactors::CreatePost.new(valid_post_attributes)
    creator.perform

    creator = Interactors::CreatePost.new(valid_post_attributes)
    response = creator.perform

    assert_equal(["is already occupied"], response.error[:id])
  end

  test "does not persist invalid posts" do
    creator = Interactors::CreatePost.new({})

    creator.perform
    assert_equal([], repository.to_a)
  end
end
