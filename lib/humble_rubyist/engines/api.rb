require 'json'

module HumbleRubyist
  module Engines

    class Api < Sinatra::Base
      include Persistence
      include Models

      get "/api/posts" do
        content_type :json
        posts = Post.all
        JSON.dump(posts: posts.map(&:values))
      end

      get "/api/posts/:id" do
        content_type :json
        if post = Post[params[:id]]
          JSON.dump(post.values)
        else
          error 404, JSON.dump(message: "Not found")
        end
      end

      post "/api/posts" do
        begin
          authorize!(params[:key])
          content_type :json
          post_params = JSON.parse(request.body.read)
          post = Post.create(post_params)
          JSON.dump(post.values)
        rescue Models::ValidationError => e
          error 400, JSON.dump(message: "Can't create post")
        end
      end

      put "/api/posts/:id" do
        begin
          authorize!(params[:key])
          post_params = JSON.parse(request.body.read)
          content_type :json
          if post = Post[params[:id]]
            post.update(post_params, ["title", "slug", "content", "published"])
            JSON.dump(post.values)
          else
            error 404, JSON.dump(message: "Not found")
          end
        rescue Models::ValidationError => e
          error 400, JSON.dump(message: "Can't update post")
        end
      end

      private

      def authorize!(key)
        #error 401 unless key.to_s == HumbleRubyist.key
      end
    end

  end
end


