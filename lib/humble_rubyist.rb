module HumbleRubyist
  PROJECT_ROOT = File.expand_path("../../", __FILE__)

  class ConfigurationError < StandardError; end

  class << self
    attr_accessor :config

    def path(relative)
      File.join(PROJECT_ROOT, relative)
    end

    def key
      File.read(path("Keyfile")).chomp
    rescue Errno::ENOENT
      raise ConfigurationError.new("Keyfile is absent")
    end

    def environment
      String(ENV["RACK_ENV"]).empty? ? :development : ENV["RACK_ENV"].to_sym
    end

    def load_config!
      self.config = eval(File.read(path("config/config.rb")))
    end
  end

  autoload :Models,      'humble_rubyist/models'
  autoload :Decorators,  'humble_rubyist/decorators'
  autoload :Presenters,  'humble_rubyist/presenters'
  autoload :Helpers,     'humble_rubyist/helpers'
  autoload :Engines,     'humble_rubyist/engines'

  autoload :Config,      'humble_rubyist/config'
  autoload :Persistence, 'humble_rubyist/persistence'
  autoload :Application, 'humble_rubyist/application'

  autoload :MarkdownPostRenderer, 'humble_rubyist/markdown_post_renderer'

  load_config!
end

