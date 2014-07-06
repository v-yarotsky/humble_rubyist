module HumbleRubyist
  module Armchair
    module Entities

      class Post < Struct.new(:id, :title, :category, :content)
        def initialize(attributes)
          attributes = Hash[attributes.map { |k, v| [k.to_s, v] }]
          super(
            String(attributes["id"]),
            String(attributes["title"]),
            String(attributes["category"]),
            String(attributes["content"]),
          )
        end

        def to_h
          Hash[each_pair.each_with_object({}) { |(k, v), r| r[k] = v }]
        end
      end

    end
  end
end

