module HumbleRubyist

  module Gravatar
    def gravatar(size = :medium)
      {
        favicon: "http://25.media.tumblr.com/avatar_29744baddf7f_16.png",
        medium: "http://25.media.tumblr.com/avatar_29744baddf7f_64.png"
      }.fetch(size)
    end
  end

end

