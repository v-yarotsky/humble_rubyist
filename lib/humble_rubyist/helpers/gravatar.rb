require 'uri'

module HumbleRubyist
  module Helpers

    module Gravatar
      def gravatar(size = :medium)
        size = { favicon: 16, medium: 64 }.fetch(size)
        URI.join(HumbleRubyist.config.gravatar, "?s=#{size}")
      end
    end

  end
end

