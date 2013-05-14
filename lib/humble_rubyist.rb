module HumbleRubyist
  PROJECT_ROOT = File.expand_path("../../", __FILE__)

  def self.path(relative)
    File.join(PROJECT_ROOT, relative)
  end
end
