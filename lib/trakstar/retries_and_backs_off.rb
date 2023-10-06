class RetriesAndBacksOff
  MAX_RETRIES = 10
  SLEEP_MULTIPLIER = 2

  attr_reader :max_retries, :sleep_multiplier

  def initialize(max_retries: MAX_RETRIES, sleep_multiplier: SLEEP_MULTIPLIER)
    @max_retries = max_retries
    @sleep_multiplier = sleep_multiplier
  end

  def call(retry_attempts = 0, &block)
    retry_attempts += 1
    block.call
  rescue
    sleep sleep_multiplier**retry_attempts
    raise if retry_attempts >= max_retries
    call(retry_attempts, &block)
  end
end
