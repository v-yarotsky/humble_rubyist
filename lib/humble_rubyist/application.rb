require 'bundler/setup'
require 'sinatra/base'
require 'slim'

require 'humble_rubyist'
require 'humble_rubyist/persistence'
require 'humble_rubyist/markdown_post_renderer'

module HumbleRubyist

  class Application < Sinatra::Base
    include Persistence
    include Models
    include Helpers::Gravatar
    include Helpers::Rendering

    use Engines::Scss
    use Engines::Coffee
    use Engines::Api

    set :views, HumbleRubyist.path("templates")

    get "/" do
      renderer = MarkdownPostRenderer.new(cut: true)
      @posts = Post.all.map { |p| Presenters::Post.new(p, renderer) }
      template 'posts/index'
    end

    get "/:permalink" do
      @post = Presenters::Post.new(Post.first)
      template 'posts/show'
    end
  end

end

