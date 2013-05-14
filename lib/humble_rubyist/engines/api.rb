require 'json'

module HumbleRubyist
  module Engines

    class Api < Sinatra::Base
      set method_override: true

      include Persistence
      include Models

      post "/api/posts" do
        error 401 unless authorized?(params[:key])
        content_type :json
        if post = Post.create(params[:post])
          JSON.dump(post.values)
        else
          error 400, JSON.dump(message: "Can't create post")
        end
      end

      get "/api/posts" do
        content_type :json
        posts = Post.all
        JSON.dump(posts: posts.map(&:values))
      end

      get %r{/api/posts/(?<date>\d{4}-\d{2}-\d{2})-(?<slug>[-\w]+)} do
        content_type :json
        if post = Post.find_by_date_and_slug(params[:date], params[:slug])
          JSON.dump(post.values)
        else
          error 404, JSON.dump(message: "Not found")
        end
      end

      put %r{/api/posts/(?<date>\d{4}-\d{2}-\d{2})-(?<slug>[-\w]+)} do
        error 401 unless authorized?(params[:key])
        content_type :json
        if post = Post.find_by_date_and_slug(params[:date], params[:slug])
          params[:post].delete("id")
          if post.update(params[:post])
            JSON.dump(post.values)
          else
            error 400, JSON.dump(message: "Can't update post")
          end
        else
          error 404, JSON.dump(message: "Not found")
        end
      end

      private

      def authorized?(key)
        key.to_s == HumbleRubyist.key
      end
    end

  end
end


