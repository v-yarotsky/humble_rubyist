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

    get %r{/(\d{4}-\d{2}-\d{2})-([-\w]+)} do
      date, slug = params[:captures]
      if @post = Post.find_by_date_and_slug(date, slug)
        @post = Presenters::Post.new(@post)
        template 'posts/show'
      else
        error 400, "Post not found"
      end
    end
  end

end

