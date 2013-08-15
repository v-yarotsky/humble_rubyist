require "mongoid"

module HumbleRubyist

  module Persistence
    def self.configure_mongodb
      Mongoid.configure do |config|
        config.raise_not_found_error = false
        config.load_configuration HumbleRubyist.config.mongodb.fetch(HumbleRubyist.environment)
      end
    end
  end

end

