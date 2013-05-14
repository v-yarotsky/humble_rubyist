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
        "/%s-%s" % [iso_published_at, @post.slug]
      end

      def published_at
        @post.published_at.strftime("%b %d, %Y")
      end

      def iso_published_at
        @post.published_at.to_date.to_s
      end
    end

  end
end
