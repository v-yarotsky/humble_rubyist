require "test_helper"
require "humble_rubyist/chair/post"

module HumbleRubyist
  module Chair

    class PostRepositoryTest < HRTest
      def setup
        @repository = PostRepository.new
        @repository.purge
      end
      alias_method :teardown, :setup

      test "makes a post" do
        post = Post.new(
          id: "a-post",
          title: "A post",
          category: "ruby",
          content: "the post"
        )

        @repository << post

        assert_equal "A post", @repository["a-post"].title
      end

      test "retains post rev" do
        post = Post.new(id: "a-post")

        @repository << post

        assert post._rev, "expected post rev to be"
      end

      test "rejects attributes that are not allowed" do
        assert_raises(Chair::BadPost) do
          @repository << Post.new(id: nil)
        end
      end

      test "rejects posts with same ID" do
        post = Post.new(
          id: "post-1",
          title: "Post 1",
          category: "ruby",
          content: "Post 1"
        )

        @repository << post

        assert_raises(Chair::DuplicatePost) do
          @repository << post
        end
      end

      test "supports basic collection interface" do
        post_1 = Post.new(id: "the-post-1")
        post_2 = Post.new(id: "the-post-2")

        @repository << post_1 << post_2

        assert_equal post_1.id, @repository["the-post-1"].id
        assert_equal post_2.id, @repository["the-post-2"].id
      end

      test "updates a post" do
        post = Post.new(id: "foo", title: "bar")
        @repository << post

        post = @repository["foo"]
        post.title = "kaboom!"
        @repository["foo"] = post

        assert_equal "kaboom!", @repository["foo"].title
      end

      test "finds all posts" do
        @repository << Post.new(id: "the-post-1", title: "Post 1") << Post.new(id: "the-post-2", title: "Post 2")

        assert_equal ["Post 1", "Post 2"], @repository.to_a.map(&:title).sort
      end
    end

  end
end
