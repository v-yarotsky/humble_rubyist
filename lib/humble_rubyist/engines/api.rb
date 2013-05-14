module HumbleRubyist
  module Engines

    class Api < Sinatra::Base
      post "/post" do
        error 401 unless authorized?(params[:key])
        Post.create(params[:post])
        json success: true
      end

      private

      def authorized?(key)
        key.to_s == HumbleRubyist.key
      end
    end

  end
end


