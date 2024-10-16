# frozen_string_literal: true

require "test_helper"

class RetriesAndBacksOffTest < Minitest::Test
  def xtest_retries_block_upto_max
    max_retries = 3
    sleep_multiplier = 0.1

    retry_and_backs_off = RetriesAndBacksOff.new(max_retries: max_retries, sleep_multiplier: sleep_multiplier)

    called = 0
    finished = false

    retry_and_backs_off.call do
      called += 1
      raise if called <= (max_retries * 2)
      finished = true
    end
  rescue Trakstar::Error
    assert_equal max_retries, called
    assert_equal false, finished
  end

  def xtest_retries_block_until_passes
    max_retries = 3
    sleep_multiplier = 0.1

    retry_and_backs_off = RetriesAndBacksOff.new(max_retries: max_retries, sleep_multiplier: sleep_multiplier)

    called = 0
    finished = false

    retry_and_backs_off.call do
      called += 1
      raise if called <= 1
      finished = true
    end

    assert_equal 2, called
    assert_equal true, finished
  end
end
