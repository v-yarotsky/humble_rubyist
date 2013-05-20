require 'bundler/setup'
require 'sinatra/base'
require 'slim'

require 'humble_rubyist'

module HumbleRubyist

  class Application < Sinatra::Base
    include Persistence
    include Models
    include Helpers::Gravatar
    include Helpers::Rendering

    set :static, true
    set :public_folder, HumbleRubyist.path("public")
    set :views, HumbleRubyist.path("templates")

    enable :raise_errors
    disable :show_exceptions

    set :slim, pretty: true

    use Engines::Admin
    use Engines::Scss
    use Engines::Coffee
    use Engines::Api

    get "/" do
      renderer = MarkdownPostRenderer.new(cut: true)
      @posts = Post.ordered_by_date.map { |p| Presenters::Post.new(p, renderer) }
      template 'posts/index'
    end

    get %r{/(?<date>\d{4}-\d{2}-\d{2})-(?<slug>[-\w]+)} do
      if @post = Post.find_by_date_and_slug(params[:date], params[:slug])
        @post = Presenters::Post.new(@post)
        template 'posts/show'
      else
        error 404, "Post not found"
      end
    end
  end

end

