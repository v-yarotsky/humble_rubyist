require 'sequel'
require 'logger'
require 'yaml'

module HumbleRubyist

  module Persistence
    class << self
      attr_accessor :connection

      def ensure_schema!
        Sequel.extension :migration
        unless Sequel::Migrator.is_current?(db, HumbleRubyist.path("migrations"))
          HumbleRubyist.debug_db!
          Sequel::Migrator.run(db, HumbleRubyist.path("migrations"))
        end
      end

      def connection_config
        db_file = HumbleRubyist.config.db.fetch(HumbleRubyist.environment)
        db_file.empty? ? "" : HumbleRubyist.path(db_file)
      end
    end

    def db
      Persistence.connection ||= begin
        Sequel.default_timezone = :utc
        connection = Sequel.sqlite(Persistence.connection_config)
        connection.use_timestamp_timezones = false
        if HumbleRubyist.debug_db?
          connection.loggers << Logger.new(STDOUT)
        end
        connection
      end
    end
    module_function :db
  end

end

