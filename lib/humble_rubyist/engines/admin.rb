require 'json'

module HumbleRubyist
  module Engines

    class Admin < Sinatra::Base
      include Helpers::Rendering
      include Helpers::Gravatar

      use Rack::Auth::Basic, "Restricted Area" do |username, password|
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


