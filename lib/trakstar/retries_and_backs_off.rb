class RetriesAndBacksOff
  MAX_RETRIES = 3
  DEFAULT_SLEEP = 60

  attr_reader :max_retries, :sleep_multiplier
  attr_accessor :error_messages

  # todo remove sleep multiplier
  def initialize(max_retries: MAX_RETRIES, time_between_failed_requests: DEFAULT_SLEEP)
    @time_between_failed_requests = time_between_failed_requests
    @max_retries = max_retries
    @error_messages = []
  end

  def call(retry_attempts = 0, &block)
    retry_attempts += 1
    block.call
  rescue JSON::ParserError => e
    raise Trakstar::Error.new("Max Retries hit. Error #{e.message}") if retry_attempts >= max_retries

    sleep @time_between_failed_requests * retry_attempts
    call(retry_attempts, &block)
  end
end
