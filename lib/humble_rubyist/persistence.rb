require 'sequel'

module HumbleRubyist

  module Persistence
    class << self
      attr_reader :db

      def included(klass)
        @db ||= begin
          Sequel.default_timezone = :utc
          db = Sequel.sqlite(HumbleRubyist.path('db/humble_rubyist.db'))
          db.use_timestamp_timezones = false

          db.create_table? :posts do
            primary_key :slug
            String      :slug
            String      :title
            String      :content
            DateTime    :published_at
            String      :icon
          end

          db
        end
        klass.send(:include, InstanceMethods)
      end
    end

    module InstanceMethods
      def db
        Persistence.db
      end
    end
  end

end

