# frozen_string_literal: true

require "test_helper"

class CandidatesTest < Minitest::Test
  def test_candidates_can_be_fetched
    VCR.use_cassette("candidates") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidates = Trakstar.candidates

      # assert_equal 1969, candidates.count

      # candidate = candidates.first

      # assert_equal "Boateng", candidate.last_name
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
