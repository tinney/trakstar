require "net/http"
require "json"

module Trakstar
  module Http
    BASE_URL = "https://api.recruiterbox.com/v2"
    LIMIT = 100
    SLEEP_FOR_LIMIT = 0.3 # limit to 3 requests a second

    def self.get_all(resource, offset: 0, query_params: {})
      wait_for_limit

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
            results += get_all(resource, offset: current_count, query_params: query_params)
          end

          return results
        else
          return []
        end
      end
    end

    def self.get(resource)
      wait_for_limit

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

    def self.post(resource, data)
      uri = URI(BASE_URL + resource)
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri)
        req.basic_auth(Trakstar.config.api_token, nil)
        req.content_type = "application/json; charset=UTF-8"
        req.body = data.to_json

        response = http.request(req)

        if response.code == "201"
          json = JSON.parse(response.body)
          json["objects"] || json
        else
          raise Trakstar::Error, "Error creating #{resource}: #{response.body}" 
        end

      end
    end

    def self.patch(resource, data)
      uri = URI(BASE_URL + resource)
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Patch.new(uri)
        req.basic_auth(Trakstar.config.api_token, nil)
        req.content_type = "application/json; charset=UTF-8"
        req.body = data.to_json

        response = http.request(req)

        if response.code == "202"
          json = JSON.parse(response.body)
          json["objects"] || json
        else
          raise Trakstar::Error, "Error updating #{resource}: #{response.body}" 
        end
      end
    end

    def self.delete(resource)
      uri = URI(BASE_URL + resource)
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Delete.new(uri)
        req.basic_auth(Trakstar.config.api_token, nil)

        response = http.request(req)

        if response.code == "204"
          return true
        else
          raise Trakstar::Error, "Error deleting #{resource}: #{response.body}" 
        end
      end
    end


    private
    def self.wait_for_limit
      @last_request ||= Time.now

      if (Time.now - @last_request) < 1
        sleep(SLEEP_FOR_LIMIT) # sleep for 0.2 seconds to avoid hitting the max
      end

      @last_request = Time.now
    end
  end
end
