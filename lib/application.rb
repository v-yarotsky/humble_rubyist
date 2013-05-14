require 'bundler/setup'
require 'sinatra/base'
require 'slim'
require 'redcarpet'
require 'pygments'

$:.unshift File.dirname(__FILE__)
require 'humble_rubyist'
require 'coffee_engine'
require 'scss_engine'

class Post
  attr_reader :title, :content, :permalink, :date, :icon

  def initialize(title, content, permalink, date, icon = :text)
    @title, @content, @permalink, @date = title, content, permalink, date, icon
  end

  class UberHTML < Redcarpet::Render::HTML
    def block_code(code, language = :ruby)
      Pygments.highlight(code, :lexer => language)
    end
  end

  def content
    renderer = Redcarpet::Markdown.new(UberHTML, no_intra_emphasis: true, fenced_code_blocks: true, autolink: true, tables: true, with_toc_data: true)
    renderer.render(@content)
  end

  def self.shellissimo
    new("Mmmmm... Shellissimo!", <<-'MD', "/2013-05-10-mmmmm-shellissimo", Date.today)
Continuing on my command-line experiments, I instantly realized how
badly I want to create a shell-like application for specific domain, because
I don't like entering same command names and all those dashes again and again
while performing a bunch of related tasks.

So was conceived [facebokr](https://github.com/v-yarotsky/facebokr).

It was pretty fun, and soon enough I found myself extracting a little framework
for constructing such applications. It was late after the midnight.
[Shellissimo](https://github.com/v-yarotsky/shellissimo) came into existence.

I thought I won't learn much new things with this project, but I was wrong.
I've learnt myself some [YARD](http://rubydoc.info/docs/yard/file/docs/Tags.md),
found out about [bundler's local gem overrides](http://gembundler.com/v1.3/git.html#local),
and finally set up test coverage monitoring with [Coveralls](https://coveralls.io/) properly.

It always strikes me how awesome it feels to create something simple yet sufficient
for task at hand.

Here is some code to get a gist of what [Shellissimo](https://github.com/v-yarotsky/shellissimo)
is all about:

```ruby
require 'shellissimo'

class Greeter; def say_hi(name, title); "Hi, #{title} #{name}"; end; end

class MyShell < Shellissimo::Shell
  command :hi do |c|
    c.description "Says hello to the user"
    c.mandatory_param(:user) do |p|
      p.description "User name"
      p.validate { |v| !v.to_s.strip.empty? }
    end
    c.param(:title) do |p|
      p.validate { |v| %w(Mr. Ms.).include?(v.to_s) }
    end
    c.run { |params| @greeter.say_hi(params[:user], params[:title]) }
  end

  def initialize
    @greeter = Greeter.new
    super
  end
end

MyShell.new.run
```

And here is some output from interaction with this shell:

```
-> h
Available commands:

hi                               - Says hello to the user
  user                           - User name - mandatory
  title                          - optional

help (aliases: h)                - Show available commands
quit (aliases: exit)             - Quit irb
-> hi user: "Vladimir"
Hi,  Vladimir
-> hi user: "Vladimir", title: "Mr."
Hi, Mr. Vladimir
-> hi user: "Vladimir", title: "Doc."
An error occured: param 'title' is not valid!
-> exit
```

There's a lot more to be done, but I believe it's a good start.
    MD
  end
end

module HumbleRubyist

  class Application < Sinatra::Base
    use ScssEngine
    use CoffeeEngine

    set :views, HumbleRubyist.path("templates")

    get "/" do
      @posts = [
        Post.shellissimo,
        Post.new("Hello", "Shazam", "/2013-05-14-hello", Date.today),
        Post.new("Test", "Works", "/2013-05-14-test", Date.today)
      ]
      template 'posts/index'
    end

    def gravatar(size = :medium)
      {
        favicon: "http://25.media.tumblr.com/avatar_29744baddf7f_16.png",
        medium: "http://25.media.tumblr.com/avatar_29744baddf7f_64.png"
      }.fetch(size)
    end

    def template(tpl, options = {})
      slim tpl.to_sym, options
    end
  end

end

