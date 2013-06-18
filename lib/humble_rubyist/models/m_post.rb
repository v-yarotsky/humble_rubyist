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

    end

  end
end
