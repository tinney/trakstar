# frozen_string_literal: true

require "test_helper"

class EvaluationsTest < Minitest::Test
  def test_evaluations_can_be_fetched_for_a_candidate
    VCR.use_cassette("evaluations") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidate_id = "67170206"
      evaluations = Trakstar.evaluations(candidate_id)

      assert_equal 3, evaluations.count

      evaluation = evaluations.last

      assert_equal 5205755364, evaluation.candidate_id
      assert_equal 6529083815, evaluation.interview_id
      assert_equal 2745784, evaluation.stage_id
      assert_equal 254644, evaluation.opening_id
      assert_equal 7479148472, evaluation.created_at
      assert_equal 408661, evaluation.interviewer_id
      assert_equal(-1, evaluation.overall_rating)
      assert_equal "isa@stiedemann.example", evaluation.interviewer_email
      assert_equal 11, evaluation.feedback.count
      assert_equal "Overall Feedback", evaluation.feedback.last.evaluation_criteria
      assert_equal(-1, evaluation.feedback.last.rating)
      assert_equal "did not like the candidate", evaluation.feedback.last.body
    end
  end
end
