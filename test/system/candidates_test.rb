# frozen_string_literal: true

require "test_helper"

class CandidatesTest < Minitest::Test
  def test_candidates_can_be_fetched
    VCR.use_cassette("candidates") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidates = Trakstar.candidates

      assert_equal 2401, candidates.count

      candidate = candidates.first

      # These fields come from the vcr_cassettes/candidates.yml
      assert_equal 44560148, candidate.api_id
      assert_equal "Jaq", candidate.first_name
      assert_equal "Smith", candidate.last_name
      assert_equal "rosendo@huels.com", candidate.email
      assert_equal 254644, candidate.opening_id
      assert_equal 2319011, candidate.stage_id
      assert_equal "Gem", candidate.source
    end
  end

  def test_candidate_can_be_fetched
    VCR.use_cassette("1_candidate") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidate = Trakstar.candidate(50049171)

      assert_equal 50049171, candidate.api_id
      assert_equal ["Java", "React", "Gem"], candidate.labels
    end
  end
end
