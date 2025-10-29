# frozen_string_literal: true

require "test_helper"

class InterviewsTest < Minitest::Test
  def test_interviews_can_be_fetched_for_a_candidate
    VCR.use_cassette("interviews") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidate_id = "41477722"
      interviews = Trakstar.interviews(candidate_id)

      assert_equal 6, interviews.count

      interview = interviews.first

      assert_equal 2719855, interview.api_id
      assert_equal "Pharmaceuticals", interview.title
      assert_equal "Down-sized mission-critical middleware", interview.description
      assert_equal 9458863971, interview.scheduled_at
      assert_equal 5104353117, interview.created_at
      assert_equal false, interview.is_cancelled
      assert_equal 41477722, interview.candidate_id
      assert_equal "shila@parisian.test", interview.interviewer_email
      assert_equal 267541, interview.interviewer_id
    end
  end
end
