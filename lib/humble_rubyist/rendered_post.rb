require 'forwardable'

module HumbleRubyist

  class RenderedPost
    extend Forwardable

    def_delegators :@post, :title, :permalink, :date, :icon

    def initialize(post, renderer)
      @post, @renderer = post, renderer
    end

    def content
      @renderer.render(@post)
    end
  end

end
