module HumbleRubyist
  module Engines

    class AdminAuthMiddleware < Rack::Auth::Basic
      def call(env)
        request = Rack::Request.new(env)
        case request.path
        when "/admin"
          super
        else
          @app.call(env)
        end
      end
    end

    class Admin < Sinatra::Base
      include Helpers::Rendering
      include Helpers::Gravatar

      use AdminAuthMiddleware, "Restricted Area" do |username, password|
        username == "admin" and password == HumbleRubyist.key
      end

      set :views, HumbleRubyist.path("templates")

      get "/admin" do
        @key = HumbleRubyist.key
        template "admin", layout: false
      end
    end

  end
end

