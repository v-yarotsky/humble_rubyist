$:.unshift File.expand_path("../lib", __FILE__)

require "rake/clean"

CLEAN << FileList["public/{js,css}/*.{js,css}"]

desc "Ensure database schema"
task :ensure_schema do |t|
  require "humble_rubyist"
  require "humble_rubyist/persistence"
  HumbleRubyist::Persistence.ensure_schema!
end

desc "Start development server"
task :server do |t|
  system("shotgun")
end

desc "Start development console"
task :console do |t|
  require "humble_rubyist/application"
  include HumbleRubyist::Persistence
  include HumbleRubyist::Models

  ARGV.clear
  require "irb"
  IRB.start
end

namespace :assets do
  desc "Precompile coffeescripts"
  task :coffeescripts do |t|
    require "pathname"
    require "bundler/setup"
    require "coffee_script"
    require "humble_rubyist"
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
    require "pathname"
    require "bundler/setup"
    require "sass"
    require "humble_rubyist"
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

namespace :db do
  desc "Create a database migration"
  task :create_migration do
    require "humble_rubyist"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    name = ARGV.last
    raise ArgumentError, "Bad migration name" unless /\A\w[\w_]*\Z/ =~ name
    migration_name = [timestamp, name].join("_")

    task name do # dirty hack
      migration_file =  HumbleRubyist.path("migrations/#{migration_name}.rb")
      File.open(migration_file, "w") do |f|
        f.write <<-EOS.strip
Sequel.migration do
  change do

  end
end
        EOS
      end
      system(ENV["EDITOR"], migration_file)
    end
  end
end

require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/humble_rubyist/**/test_*.rb'].exclude(/test_helper\.rb/)
end

Rake::TestTask.new(:acceptance_test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/acceptance/**/test_*.rb'].exclude(/test_helper\.rb/)
end

task :default => [:test, :acceptance_test]
