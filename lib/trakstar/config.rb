module Trakstar
  class Config
    attr_accessor :api_token, :sleep_multiplier, :max_retry_attempts

    DEFAULT_SLEEP_MULTIPLIER = 2
    DEFAULT_MAX_RETRY_ATTEMPTS = 3

    def set(**attrs)
      @api_token = attrs[:api_token] if attrs.key?(:api_token)

      @sleep_multiplier = attrs[:sleep_multiplier] || DEFAULT_SLEEP_MULTIPLIER
      @max_retry_attempts = attrs[:max_retry_attempts] || DEFAULT_MAX_RETRY_ATTEMPTS
    end
  end
end
