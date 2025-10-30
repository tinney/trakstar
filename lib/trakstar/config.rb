module Trakstar
  class Config
    attr_accessor :api_token, :time_between_failed_requests, :max_retry_attempts

    DEFAULT_TIME_BETWEEN_FAILED_REQUESTS = 60
    DEFAULT_MAX_RETRY_ATTEMPTS = 3

    def set(**attrs)
      @api_token = attrs[:api_token] if attrs.key?(:api_token)

      @time_between_failed_requests = attrs[:time_between_failed_requests] || DEFAULT_TIME_BETWEEN_FAILED_REQUESTS
      @max_retry_attempts = attrs[:max_retry_attempts] || DEFAULT_MAX_RETRY_ATTEMPTS
    end
  end
end
