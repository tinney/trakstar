# frozen_string_literal: true

require "test_helper"

class RetriesAndBacksOffTest < Minitest::Test
  def test_retries_block_upto_max
    max_retries = 3
    time_between_failed_requests = 0.1

    retry_and_backs_off = RetriesAndBacksOff.new(max_retries: max_retries, time_between_failed_requests: time_between_failed_requests)

    called = 0
    finished = false

    retry_and_backs_off.call do
      called += 1
      raise JSON::ParserError.new if called <= (max_retries * 2)
      finished = true
    end
  rescue Trakstar::Error
    assert_equal max_retries, called
    assert_equal false, finished
  end

  def test_call_does_not_retry_if_not_json_error
    max_retries = 3
    time_between_failed_requests = 0.1

    retry_and_backs_off = RetriesAndBacksOff.new(max_retries: max_retries, time_between_failed_requests: time_between_failed_requests)

    called = 0
    finished = false

    begin
      retry_and_backs_off.call do
        called += 1
        raise if called <= 1
        finished = true
      end
    rescue
      assert_equal 1, called
      assert_equal false, finished
    end
  end

  def test_retries_catches_json
    max_retries = 3
    time_between_failed_requests = 0.1

    retry_and_backs_off = RetriesAndBacksOff.new(max_retries: max_retries, time_between_failed_requests: time_between_failed_requests)

    called = 0
    finished = false

    retry_and_backs_off.call do
      called += 1
      JSON.parse("<html>invalid json response</html>") if called <= 1
      finished = true
    end

    assert_equal 2, called
    assert_equal true, finished
  end
end
