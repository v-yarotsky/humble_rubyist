require "sass"

module HumbleRubyist
  module Engines

    class Scss < Sinatra::Base
      set :views, HumbleRubyist.path("assets/scss")

      get "/css/*.css" do
        filename = params[:splat].flatten.first
        scss filename.to_sym
      end
    end

  end
end

