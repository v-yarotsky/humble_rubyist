module HumbleRubyist
  module Armchair

    class Response
      attr_accessor :body, :error

      def initialize(body = {})
        @body = body.to_h
        @error = {}
      end

      def merge!(body_attributes)
        @body.merge!(body_attributes)
      end

      def error!(on, message)
        (@error[on.to_sym] ||= []) << message.to_s
      end
    end

  end
end
