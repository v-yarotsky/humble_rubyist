require "coffee-script"

module HumbleRubyist
  module Engines

    class Coffee < Sinatra::Base
      set :views, HumbleRubyist.path("assets/coffeescripts")

      get "/js/*.js" do
        filename = params[:splat].flatten.first
        coffee filename.to_sym
      end
    end

  end
end

