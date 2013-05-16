require 'sequel'
require 'logger'

module HumbleRubyist

  module Persistence
    class << self
      attr_reader :db

      def included(klass)
        klass.send(:include, InstanceMethods)
        db
      end

      def db
        @db ||= begin
          Sequel.default_timezone = :utc
          db = Sequel.sqlite(HumbleRubyist.path('db/humble_rubyist.db'))
          db.use_timestamp_timezones = false
          db.loggers << Logger.new(STDOUT)
          db
        end
      end

      def ensure_schema!
        db.create_table? :posts do
          primary_key :id
          String      :slug
          String      :title
          String      :content
          DateTime    :published_at
          String      :icon

          unique [:slug, :published_at]
        end
      end
    end

    module InstanceMethods
      def db
        Persistence.db
      end
    end
  end

end

