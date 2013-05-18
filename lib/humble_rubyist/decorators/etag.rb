require 'delegate'

module HumbleRubyist
  module Decorators

    class Etag < SimpleDelegator
      class InappropriateEtagSubjectError < StandardError; end

      def self.wrap(things)
        case things
        when Sequel::Model
          new(things)
        when Enumerable
          things.map(&method(:new))
        else
          raise InappropriateEtagSubjectError, things
        end
      end

      def initialize(obj)
        super(obj)
      end

      def etag
        values.hash
      end
    end

  end
end
