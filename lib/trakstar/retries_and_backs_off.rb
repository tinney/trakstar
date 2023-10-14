class RetriesAndBacksOff
  MAX_RETRIES = 3
  SLEEP_MULTIPLIER = 5

  attr_reader :max_retries, :sleep_multiplier
  attr_accessor :error_messages

  def initialize(max_retries: MAX_RETRIES, sleep_multiplier: SLEEP_MULTIPLIER)
    @max_retries = max_retries
    @sleep_multiplier = sleep_multiplier
    @error_messages = []
  end

  def call(retry_attempts = 0, &block)
    retry_attempts += 1
    block.call
  rescue => e
    sleep sleep_multiplier**retry_attempts

    raise Trakstar::Error.new("Max Retries hit. Error #{e.message}") if retry_attempts >= max_retries
    call(retry_attempts, &block)
  end
end
