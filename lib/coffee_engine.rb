require 'coffee-script'

module HumbleRubyist

  class CoffeeEngine < Sinatra::Base
    set :views, HumbleRubyist.path("assets/coffeescripts")

    get "/javascripts/*.js" do
      filename = params[:splat].flatten.first
      coffee filename.to_sym
    end
  end

end

