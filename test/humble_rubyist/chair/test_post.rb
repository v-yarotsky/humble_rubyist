require "test_helper"
require "humble_rubyist/chair/post"

module HumbleRubyist
  module Chair

    class PostRepositoryTest < HRTest
      def setup
        PostRepository.new.purge
      end
      alias_method :teardown, :setup

      test "makes a post" do
        post = PostRepository.create!(
          id: "a-post",
          title: "A post",
          category: "ruby",
          content: "the post"
        )
        assert_equal "A post", PostRepository.get("a-post").title
      end

      test "rejects attributes that are not allowed" do
        assert_raises(Chair::BadPost) do
          PostRepository.create!(id: nil)
        end
      end

      test "rejects posts with same ID" do
        post_attributes = {
          id: "post-1",
          title: "Post 1",
          category: "ruby",
          content: "Post 1"
        }

        PostRepository.create!(post_attributes)

        assert_raises(Chair::DuplicatePost) do
          PostRepository.create!(post_attributes)
        end
      end

      test "updates a post"
      test "finds a post"
      test "finds all posts"
    end

  end
end
