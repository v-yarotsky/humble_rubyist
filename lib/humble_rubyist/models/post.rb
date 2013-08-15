module HumbleRubyist
  module Models

    class Post
      include Mongoid::Document

      field :category,     type: String
      field :title,        type: String
      field :slug,         type: String
      field :content,      type: String
      field :created_at,   type: Time
      field :published_at, type: Time

      validates_presence_of :title, :slug, :content

      def self.published(posts)
        posts.select(&:published?)
      end

      def self.find_by_date_and_slug(date, slug)
        date = date.to_time(:local)
        find_by(
          :published_at.gte => date.beginning_of_day,
          :published_at.lte => date.end_of_day,
          :slug => slug
        )
      end

      def self.ordered_by_date(posts)
        posts.to_a.sort_by(&:published_at).reverse
      end

      def self.create!(attributes)
        super
      rescue Mongoid::Errors::Validations => e
        raise ValidationError, e
      end

      def update!(attributes, fields = nil)
        fields_to_update = Array(fields)
        attribute_values = fields_to_update.empty? ? attributes : Hash[attributes.select { |k, v| fields_to_update.include? k }]
        update_attributes!(attribute_values)
      rescue Mongoid::Errors::Validations => e
        raise ValidationError, e
      end

      def published?
        !!published_at
      end

      def values
        result = attributes
        result["id"] = result.delete("_id").to_s
        result["published"] = published?
        result
      end
    end

  end
end
