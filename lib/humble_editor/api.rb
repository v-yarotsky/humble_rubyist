require 'net/http'

module HumbleEditor

  class Api
    def initialize(api_root, key)
      @key = key
      raise ArgumentError, "Need API key!" if String(@key).empty?
      @api_root = api_root
      raise ArgumentError, "Need API host!" if String(@api_root).empty?
    end

    def get(api_path)
      uri = api_uri(api_path)
      request = Net::HTTP::Get.new(uri.path)
      response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
      json_result(response)
    end

    def post(api_path, params = {})
      uri = api_uri(api_path)
      request = Net::HTTP::Post.new(uri.path)
      request.form_data = params.merge(key: @key)
      response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
      json_result(response)
    end

    def put(api_path, params = {})
      post api_path, params.merge(:_method => "PUT")
    end

    private

    def api_uri(api_path)
      URI.join(@api_root, api_path)
    end

    def json_result(response)
      JSON.parse(response.body).merge(success: response.code == "200")
    end
  end

end


