HumbleRubyist::Config.new do |c|
  c.gravatar = "http://www.gravatar.com/avatar/4fbcc6dafbf12135c54172d881f6e74a.png"

  c.db = {
    development: "db/humble_rubyist_development.db",
    test: "",
    production: "db/humble_rubyist.db"
  }
end

