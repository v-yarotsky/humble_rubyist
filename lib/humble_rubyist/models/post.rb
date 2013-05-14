module HumbleRubyist
  module Models

    class Post < Sequel::Model
      def self.find_by_date_and_slug(date, slug)
        where(Sequel.lit("date(published_at)") => date, :slug => slug).first
      end
    end

  end
end

