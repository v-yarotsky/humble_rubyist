require 'forwardable'

require 'humble_rubyist/markdown_post_renderer'

module HumbleRubyist
  module Presenters

    class Post
      extend Forwardable

      def_delegators :@post, :title, :published_at, :icon

      def initialize(post, renderer = MarkdownPostRenderer.new)
        @post, @renderer = post, renderer
      end

      def content
        @renderer.render(@post)
      end

      def permalink
        "/%s-%s" % [@post.published_at.to_date, @post.slug]
      end
    end

  end
end
