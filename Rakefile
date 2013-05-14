desc "Start development server"
task :server do |t|
  system("shotgun")
end

desc "Start development console"
task :console do |t|
  $:.unshift File.expand_path("../lib", __FILE__)
  require 'humble_rubyist/application'
  include HumbleRubyist::Persistence
  include HumbleRubyist::Models

  ARGV.clear
  require 'irb'
  IRB.start
end

task :default => :server
