module Trakstar
  class Config
    attr_accessor :api_token

    def set(**attrs)
      @api_token = attrs[:api_token] if attrs.key?(:api_token)
    end
  end
end
