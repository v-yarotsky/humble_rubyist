require "delegate"

module HumbleRubyist
  module Decorators

    #
    # Wraps a Sequel::Model or an enumerable of Sequel::Models
    # adds #etag
    #
    class Etag < SimpleDelegator
      class InappropriateEtagSubjectError < StandardError; end

      def etag
        if __getobj__.kind_of?(Enumerable)
          __getobj__.inject(1) { |hash, m| m.values.hash ^ hash }
        elsif __getobj__.respond_to?(:values)
          __getobj__.values.hash
        else
          raise InappropriateEtagSubjectError, __getobj__
        end
      end
    end

  end
end
