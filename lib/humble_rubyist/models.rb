module HumbleRubyist
  module Models
    class ValidationError < StandardError; end

    Persistence.configure_mongodb

    autoload :Post, "humble_rubyist/models/post"
  end
end

