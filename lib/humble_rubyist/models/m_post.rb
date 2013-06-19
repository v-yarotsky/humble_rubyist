module HumbleRubyist
  module Models

    class MPost
      include Mongoid::Document

      field :category,     type: String
      field :title,        type: String
      field :slug,         type: String
      field :content,      type: String
      field :created_at,   type: Time
      field :published_at, type: Time

      validates_presence_of :title, :slug, :content

      def self.migrate_from_sequel
        Post.all.each do |p|
          create(
            category:      p.icon,
            title:         p.title,
            slug:          p.slug,
            content:       p.content,
            created_at:    p.published_at,
            published_at:  p.published_at
          )
        end
      end

      def self.published(posts)
        posts.select(&:published?)
      end

      def self.find_by_date_and_slug(date, slug)
        find_by(
          :published_at.gte => date.to_time.beginning_of_day,
          :published_at.lte => date.to_time.end_of_day,
          :slug => slug
        )
      end

      def self.ordered_by_date
        all.to_a.sort_by(&:published_at).reverse
      end

      def self.create!(attributes)
        super
      rescue Mongoid::Errors::Validations => e
        raise ValidationError, e
      end

      def update!(*args)
        update_attributes!(*args)
      rescue Mongoid::Errors::Validations => e
        raise ValidationError, e
      end

      def published?
        !!published_at
      end

    end

  end
end
