require 'sequel'

module HumbleRubyist

  module Persistence
    attr_reader :db

    def self.included(klass)
      @db = Sequel.sqlite(HumbleRubyist.path('db/humble_rubyist.db'))

      @db.create_table? :posts do
        primary_key :slug
        String :slug
        String :title
        String :content
        Time   :published_at
        String :icon
      end
    end
  end

end

