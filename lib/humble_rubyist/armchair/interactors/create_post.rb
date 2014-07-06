module HumbleRubyist
  module Armchair
    module Interactors

      class CreatePost
        attr_accessor :repository

        def initialize(params)
          @post = Entities::Post.new(params)
          @response = Response.new(@post)
          @repository = Armchair.inject_dependency(:posts_repository)
        end

        def perform
          validator = Validators::PostValidator.new(@response)
          validator.ensure_valid_and_yield(@post) do
            @repository.push(@post)
          end
          @response
        end
      end

    end
  end
end

