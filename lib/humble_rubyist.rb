module HumbleRubyist
  PROJECT_ROOT = File.expand_path("../../", __FILE__)

  class ConfigurationError < StandardError; end

  def self.path(relative)
    File.join(PROJECT_ROOT, relative)
  end

  def self.key
    File.read(path("Keyfile")).chomp
  rescue Errno::ENOENT
    raise ConfigurationError.new("Keyfile is absent")
  end

  autoload :Models,     'humble_rubyist/models'
  autoload :Decorators, 'humble_rubyist/decorators'
  autoload :Presenters, 'humble_rubyist/presenters'
  autoload :Helpers,    'humble_rubyist/helpers'
  autoload :Engines,    'humble_rubyist/engines'
end

