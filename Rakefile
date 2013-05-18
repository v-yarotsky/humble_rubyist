$:.unshift File.expand_path("../lib", __FILE__)

require 'rake/clean'

CLEAN << FileList["public/{js,css}/*.{js,css}"]

desc "Ensure database schema"
task :ensure_schema do |t|
  require 'humble_rubyist'
  require 'humble_rubyist/persistence'
  HumbleRubyist::Persistence.ensure_schema!
end

desc "Start development server"
task :server do |t|
  system("shotgun")
end

desc "Start development console"
task :console do |t|
  require 'humble_rubyist/application'
  include HumbleRubyist::Persistence
  include HumbleRubyist::Models

  ARGV.clear
  require 'irb'
  IRB.start
end

desc "Start editor shell"
task :editor do |t|
  require 'humble_editor/application'
end

namespace :assets do
  desc "Precompile coffeescripts"
  task :coffeescripts do |t|
    require 'pathname'
    require 'bundler/setup'
    require 'coffee_script'
    require 'humble_rubyist'
    coffeescripts = Pathname.new HumbleRubyist.path("assets/coffeescripts")
    javascripts = Pathname.new HumbleRubyist.path("public/js")
    Dir.glob(File.join(coffeescripts, "**", "*.coffee")).each do |f|
      compiled = CoffeeScript.compile(File.read(f))
      relative_filename = Pathname.new(f).relative_path_from(coffeescripts)
      js_filename = javascripts.join(relative_filename).sub_ext(".js")
      File.open(js_filename, "w") { |w| w.write(compiled) }
    end
  end

  desc "Precompile stylesheets"
  task :stylesheets do |t|
    require 'pathname'
    require 'bundler/setup'
    require 'sass'
    require 'humble_rubyist'
    scss = Pathname.new HumbleRubyist.path("assets/scss")
    stylesheets = Pathname.new HumbleRubyist.path("public/css")
    Dir.glob(File.join(scss, "**", "*.scss")).each do |f|
      compiled = Sass.compile(File.read(f))
      relative_filename = Pathname.new(f).relative_path_from(scss)
      css_filename = stylesheets.join(relative_filename).sub_ext(".css")
      File.open(css_filename, "w") { |w| w.write(compiled) }
    end
  end

  desc "Precompile assets"
  task :precompile => [:coffeescripts, :stylesheets]
end

task :default => :server
