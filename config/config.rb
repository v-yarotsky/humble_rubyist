HumbleRubyist::Config.new do |c|
  c.gravatar = "http://www.gravatar.com/avatar/4fbcc6dafbf12135c54172d881f6e74a.png"

  c.db = {
    development:  "db/humble_rubyist_development.db",
    test:         "",
    production:   "db/humble_rubyist.db"
  }

  c.mongodb = {
    development: {
      sessions: {
        default: {
          database:  "humble_rubyist_development",
          hosts:     ["localhost:27017"]
        }
      }
    },
    test: {
      sessions: {
        default: {
          database:  "humble_rubyist_test",
          hosts:     ["localhost:27017"]
        }
      }
    },
    production: {
      sessions: {
        default: {
          database:  "humble_rubyist",
          hosts:     ["localhost:27017"]
        }
      }
    }
  }
end

