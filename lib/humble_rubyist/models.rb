require 'sequel'

module HumbleRubyist
  module Models
    class ValidationError < StandardError; end

    include Persistence
    Sequel::Model.db = Persistence.db

    Persistence.configure_mongodb

    autoload :Post, 'humble_rubyist/models/post'
    autoload :MPost, 'humble_rubyist/models/m_post'
  end
end

