require 'humble_rubyist/armchair/errors'

module HumbleRubyist

  module Armchair
    module Entities
      autoload :Post, 'humble_rubyist/armchair/entities/post'
    end

    module Validators
      autoload :PostValidator, 'humble_rubyist/armchair/validators/post_validator'
    end

    module Interactors
      autoload :CreatePost, 'humble_rubyist/armchair/interactors/create_post'
    end

    autoload :Response,    'humble_rubyist/armchair/response'

    def self.inject_dependency(name)
      @dependencies.fetch(name).call
    end

    def self.register_dependency(name, &maker)
      @dependencies.store(name, maker)
    end

    def self.setup_default_dependencies
      register_dependency :posts_repository do
        # Repositories::PostRepository.new
        []
      end
    end

    def self.reset_dependencies!
      @dependencies = {}
      setup_default_dependencies
    end

    reset_dependencies!
  end

end

