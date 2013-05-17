module HumbleRubyist
  module Models

    class Post < Sequel::Model
      def self.ordered_by_date
        all.sort_by(&:published_at).reverse
      end

      def self.find_by_date_and_slug(date, slug)
        where(Sequel.lit("date(published_at)") => date, :slug => slug).first
      end
    end

  end
end

