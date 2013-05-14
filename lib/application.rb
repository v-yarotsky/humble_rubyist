require 'bundler/setup'
require 'sinatra/base'
require 'slim'

$:.unshift File.dirname(__FILE__)
require 'humble_rubyist'
require 'humble_rubyist/post'
require 'humble_rubyist/gravatar'
require 'humble_rubyist/markdown_post_renderer'
require 'humble_rubyist/rendered_post'
require 'coffee_engine'
require 'scss_engine'

module HumbleRubyist

  class Application < Sinatra::Base
    include Gravatar

    use ScssEngine
    use CoffeeEngine

    set :views, HumbleRubyist.path("templates")

    get "/" do
      renderer = MarkdownPostRenderer.new(cut: true)
      @posts = [
        Post.shellissimo,
        Post.new("Hello", "Shazam", "/2013-05-14-hello", Date.today),
        Post.new("Test", "Works", "/2013-05-14-test", Date.today)
      ].map { |p| RenderedPost.new(p, renderer) }
      template 'posts/index'
    end

    get "/:permalink" do
      @post = RenderedPost.new(Post.shellissimo, MarkdownPostRenderer.new)
      template 'posts/show'
    end

    def template(tpl, options = {})
      slim tpl.to_sym, options
    end
  end

end

