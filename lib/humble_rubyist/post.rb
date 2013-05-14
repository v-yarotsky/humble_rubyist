module HumbleRubyist

  class Post
    attr_reader :title, :content, :permalink, :date, :icon

    def initialize(title, content, permalink, date, icon = :text)
      @title, @content, @permalink, @date, @icon = title, content, permalink, date, icon
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

<!-- more -->

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

end

