$:.unshift File.expand_path("../lib", __FILE__)

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

task :default => :server
