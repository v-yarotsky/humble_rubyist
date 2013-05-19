require 'sequel'
require 'logger'
require 'yaml'
require 'humble_rubyist'

module HumbleRubyist

  module Persistence
    class << self
      attr_reader :db

      def included(klass)
        klass.send(:include, InstanceMethods)
        db
      end

      def environment
        ENV["RACK_ENV"] || "development"
      end

      def db
        @db ||= begin
          Sequel.default_timezone = :utc
          connection = YAML.load(File.read(HumbleRubyist.path("config/database.yml")))[environment]
          db = Sequel.sqlite(connection.empty? ? "" : HumbleRubyist.path(connection))
          db.use_timestamp_timezones = false
          if environment == "development"
            db.loggers << Logger.new(STDOUT)
          end
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

