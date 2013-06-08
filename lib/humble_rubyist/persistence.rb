require 'sequel'
require 'logger'
require 'yaml'

module HumbleRubyist

  module Persistence
    class << self
      attr_accessor :connection

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

    def db
      Persistence.connection ||= begin
        Sequel.default_timezone = :utc
        connection_config = HumbleRubyist.config.db.fetch(HumbleRubyist.environment)
        connection = Sequel.sqlite(connection_config.empty? ? "" : HumbleRubyist.path(connection_config))
        connection.use_timestamp_timezones = false
        if HumbleRubyist.environment == :development
          connection.loggers << Logger.new(STDOUT)
        end
        connection
      end
    end
    module_function :db
  end

end

