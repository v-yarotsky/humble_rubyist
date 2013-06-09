module HumbleRubyist
  module Models

    class Post < Sequel::Model
      plugin :validation_helpers

      def self.ordered_by_date
        all.sort_by(&:published_at).reverse
      end

      def self.published(posts)
        posts.select(&:published)
      end

      def self.find_by_date_and_slug(date, slug)
        where(Sequel.lit("date(published_at)") => date, :slug => slug).first
      end

      def self.create(*)
        super
      rescue Sequel::ValidationFailed => e
        raise ValidationError, e
      end

      def update(params, fields)
        set_fields(params, fields)
        save
      rescue Sequel::ValidationFailed => e
        raise ValidationError, e
      end

      def validate
        validates_presence [:title, :slug, :content]
      end
    end

  end
end

