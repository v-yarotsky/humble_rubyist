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
          p response
          puts JSON.parse(response.body) rescue nil
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

      def create!(attributes)
        # validations
        if attributes[:id].nil?
          raise BadPost, "Post must have an ID"
        end

        # create database
        couch.put(database) rescue nil

        # create actual post
        result = couch.put(database + "/" + attributes[:id], body: attributes)
      rescue Couch::Conflict => e
        raise DuplicatePost, "Post with ID=#{attributes[:id]} already exists!"
      end

      def get(id)
        response = couch.get(database + "/" + id)
        OpenStruct.new(response)
      end

      def purge
        couch.delete(database)
      end

      def database
        "/humble_rubyist_posts_#{HumbleRubyist.environment}"
      end
    end

  end
end
