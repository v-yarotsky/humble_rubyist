require 'bundler/setup'

require 'humble_editor/editor'
require 'humble_editor/shell'

require 'optparse'
require 'yaml'

Signal.trap("SIGINT") do
  puts "Terminating"
  exit 1
end

DEFAULT_CONFIG_FILE = File.expand_path("~/.humble_editor.yml")

config_file = DEFAULT_CONFIG_FILE

options = {}

OptionParser.new do |opts|
  opts.on("-h API_HOST", "--api-host", "HumbleRubyist API host") { |v| options[:api_host] = v }
  opts.on("-k KEY", "--key", "HumbleRubyist API key") { |v| options[:api_key] = v }
  opts.on("-c CONFIG", "--config", "Custom HumbleEditor config file") { |v| config_file = v }
end.parse!

if File.exists?(config_file)
  config_options = YAML.load(File.read(config_file)).inject({}) { |r, (k, v)| r[k.to_sym] = v; r }
  options = config_options.merge(options)
end
p options

app = HumbleEditor::Editor.new(options[:api_host], options[:api_key])
HumbleEditor::Shell.new(app).run

