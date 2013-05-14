require 'sass'

module HumbleRubyist

  class ScssEngine < Sinatra::Base
    set :views, HumbleRubyist.path("assets/scss")

    get "/stylesheets/*.css" do
      filename = params[:splat].flatten.first
      scss filename.to_sym
    end
  end

end
