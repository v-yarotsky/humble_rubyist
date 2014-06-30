require 'net/http'
require 'uri'
require 'json'
require 'ostruct'

module HumbleRubyist
  module Chair

    class Couch
      class Conflict < StandardError; end

      attr_reader :couch_uri

      def self.default
        config = HumbleRubyist.config.couchdb[HumbleRubyist.environment]
        Couch.new(config[:host])
      end

      def initialize(couch_uri)
        @couch_uri = URI.parse(couch_uri.to_s)
      end

      def get(path)
        request(:get, path)
      end

      def put(path, body: nil)
        request(:put, path, body: body)
      end

      def delete(path)
        request(:delete, path)
      end

      private

      def request(type, path, body: nil, headers: {})
        headers = { "Content-Type" => "application/json" }.merge(headers)
        http = Net::HTTP.new(couch_uri.host, couch_uri.port)
        # http.set_debug_output(STDERR)
        request = request_klass(type).new(path)
        request.body = JSON.dump(body) if body
        headers.each { |k, v| request[k] = v }
        response = http.start { |http| http.request(request) }

        case response
        when Net::HTTPSuccess
          JSON.parse(response.body)
        when Net::HTTPConflict
          raise Conflict, JSON.parse(response.body)
        else
          #p response
          #puts JSON.parse(response.body) rescue nil
          nil
        end
      end

      def request_klass(request_type)
        {
          get: Net::HTTP::Get,
          put: Net::HTTP::Put,
          delete: Net::HTTP::Delete
        }[request_type]
      end
    end

    class BadPost < StandardError; end
    class DuplicatePost < StandardError; end

    class Post < Struct.new(:id, :title, :category, :content, :created_at, :published_at, :_rev)
      def initialize(attributes)
        attributes = Hash[attributes.map { |k, v| [k.to_s, v] }]
        super(
          attributes["id"],
          attributes["title"],
          attributes["category"],
          attributes["content"],
          attributes["created_at"],
          attributes["published_at"],
          attributes["_rev"]
        )
      end

      def id
        raise BadPost, "Post must have an id" if self[:id].nil?
        self[:id]
      end

      def to_h
        Hash[each_pair.each_with_object({}) { |(k, v), r| r[k] = v unless v.nil? }]
      end
    end

    class PostRepository
      def self.create!(attributes)
        new.create!(attributes)
      end

      def self.get(id)
        new.get(id)
      end

      attr_reader :couch

      def initialize(couch = Couch.default)
        @couch = couch
      end

      def <<(post)
        # create database
        couch.put(database) rescue nil

        # create actual post
        response = couch.put(db_url(post.id), body: post.to_h)
        post._rev = response["rev"]
        self
      rescue Couch::Conflict => e
        raise DuplicatePost, "Post with ID=#{post.id} already exists!"
      end

      def [](post_id)
        response = couch.get(db_url(post_id))
        Post.new(response)
      end

      def []=(post_id, post)
        Post.new(couch.put(db_url(post.id), body: post.to_h))
      end

      def to_a
        response = couch.get(db_url("_all_docs?include_docs=true"))
        response["rows"].map { |row| Post.new(row["doc"]) }
      end

      def purge
        couch.delete(database)
      end

      def db_url(*elements)
        [database, *elements].join("/")
      end

      def database
        "/humble_rubyist_posts_#{HumbleRubyist.environment}"
      end
    end

  end
end
