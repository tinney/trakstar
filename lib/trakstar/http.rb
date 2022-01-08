require "net/http"
require "json"

module Trakstar
  module Http
    BASE_URL = "https://api.recruiterbox.com/v2"
    LIMIT = 100

    def self.wait
      @last_request ||= Time.now
      sleep_time = [0, 1.5 - (Time.now - @last_request)].max
      sleep(sleep_time)
      @last_request = Time.now
    end

    def self.get_all(resource, offset: 0, query_params: {})
      wait
      params = query_params.map { |key, value| "#{key}=#{value}" }.join("&")

      uri = URI(BASE_URL + resource + "/?limit=#{LIMIT}&offset=#{offset}&#{params}")

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        req.basic_auth(Trakstar.config.api_token, nil)
        response = http.request(req)

        json = JSON.parse(response.body)

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
      wait
      uri = URI(BASE_URL + resource)

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        req.basic_auth(Trakstar.config.api_token, nil)
        response = http.request(req)

        json = JSON.parse(response.body)
        json["objects"] || json
      end
    end
  end
end
