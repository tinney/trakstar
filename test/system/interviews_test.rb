# frozen_string_literal: true

require "test_helper"

class InterviewsTest < Minitest::Test
  def test_interviews_can_be_fetched_for_a_candidate
    VCR.use_cassette("interviews") do
      Trakstar.config(api_token: "abc123-api-token")
      candidate_id = "41477722"
      interviews = Trakstar.interviews(candidate_id)

      assert_equal 6, interviews.count

      interview = interviews.first

      assert_equal "Take Home Review", interview.title
      assert_equal 41477722, interview.candidate_id
      # assert_equal 465483, staff_opening.api_id
      # assert_equal "Published", staff_opening.state
      # assert_equal false, staff_opening.private

      # assert_equal 15, staff_opening.stages.count

      # stage = staff_opening.stages.first
      # assert_equal 0, stage.position
      # assert_equal 4093864, stage.api_id
    end
  end
end
