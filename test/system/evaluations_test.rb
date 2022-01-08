# frozen_string_literal: true

require "test_helper"

class EvaluationsTest < Minitest::Test
  def test_evaluations_can_be_fetched_for_a_candidate
    VCR.use_cassette("evaluations") do
      Trakstar.config(api_token: "abc123-api-token")
      candidate_id = "41477722"
      evaluations = Trakstar.evaluations(candidate_id)

      assert_equal 6, evaluations.count
      # assert_equal 41477722, evaluations.first.candidate_id
      # assert_equal [nil, nil, 0, nil, 1, 1], evaluations.map(&:overall_rating)
    end
  end
end
