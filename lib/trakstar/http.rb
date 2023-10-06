require "net/http"
require "json"

module Trakstar
  module Http
    BASE_URL = "https://api.recruiterbox.com/v2"
    LIMIT = 100

    def self.get_all(resource, offset: 0, query_params: {})
      params = query_params.map { |key, value| "#{key}=#{value}" }.join("&")
      uri = URI(BASE_URL + resource + "/?limit=#{LIMIT}&offset=#{offset}&#{params}")

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        req.basic_auth(Trakstar.config.api_token, nil)

        # Note: JSON will fail as the response body is just a string
        json = Trakstar.retries_and_backs_off do
          response = http.request(req)
          JSON.parse(response.body)
        end

        if (results = json["objects"])
          total = json.dig("meta", "total")
          current_count = offset + results.count

          if total > current_count
            results += get_all(resource, offset: current_count)
          end

          return results
        else
          return []
        end
      end
    end

    def self.get(resource)
      uri = URI(BASE_URL + resource)

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        req.basic_auth(Trakstar.config.api_token, nil)

        json = Trakstar.retries_and_backs_off do
          response = http.request(req)
          JSON.parse(response.body)
        end

        json["objects"] || json
      end
    end
  end
end
