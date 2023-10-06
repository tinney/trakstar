# frozen_string_literal: true

require "test_helper"

class OpeningsTest < Minitest::Test
  def test_openings_can_be_fetched
    VCR.use_cassette("openings_and_stages") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      openings = Trakstar.openings
      staff_opening = openings.first

      assert_equal 29, openings.count

      assert_equal "Software Consultant", staff_opening.title
      assert_equal 592579, staff_opening.api_id
      assert_equal "Ohio", staff_opening.state
      assert_equal false, staff_opening.private

      assert_equal 13, staff_opening.stages.count
      stage = staff_opening.stages.first
      assert_equal 5217700, stage.api_id
    end
  end
end
