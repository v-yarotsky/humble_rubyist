require 'rest_client'
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
      response = RestClient.get api_uri(api_path),
        accept: :json
      json_result(response)
    end

    def post(api_path, data, params = {})
      response = RestClient.post api_uri(api_path),
        data.to_json,
        content_type: :json,
        accept: :json
      json_result(response)
    end

    def put(api_path, data, params = {})
      response = RestClient.put api_uri(api_path),
        data.to_json,
        content_type: :json,
        accept: :json
      json_result(response)
    end

    private

    def api_uri(api_path)
      URI.join(@api_root, api_path).to_s
    end

    def json_result(response)
      JSON.parse(response.body).merge(success: response.code == 200)
    end
  end

end


