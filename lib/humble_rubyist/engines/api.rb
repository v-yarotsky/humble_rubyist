require 'json'

module HumbleRubyist
  module Engines

    class Api < Sinatra::Base
      include Persistence
      include Models

      post "/api/posts" do
        authorize!(params[:key])
        content_type :json
        post_params = JSON.parse(request.body.read)
        if post = Post.create(post_params)
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

      get "/api/posts/:id" do
        content_type :json
        if post = Post[params[:id]]
          JSON.dump(post.values)
        else
          error 404, JSON.dump(message: "Not found")
        end
      end

      put "/api/posts/:id" do
        authorize!(params[:key])
        post_params = JSON.parse(request.body.read)
        content_type :json
        if post = Post[params[:id]]
          post.set_fields(post_params, ["title", "slug", "content"])
          if post.save
            JSON.dump(post.values)
          else
            error 400, JSON.dump(message: "Can't update post")
          end
        else
          error 404, JSON.dump(message: "Not found")
        end
      end

      private

      def authorize!(key)
        #error 401 unless key.to_s == HumbleRubyist.key
      end
    end

  end
end


