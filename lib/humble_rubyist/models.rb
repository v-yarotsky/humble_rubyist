require 'sequel'

module HumbleRubyist
  module Models

    include Persistence
    Sequel::Model.db = Persistence.db

    autoload :Post, 'humble_rubyist/models/post'

  end
end

