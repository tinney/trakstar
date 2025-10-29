# frozen_string_literal: true

require "test_helper"

class OpeningsTest < Minitest::Test
  def test_openings_can_be_fetched
    VCR.use_cassette("openings_and_stages") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      openings = Trakstar.openings
      staff_opening = openings.first

      assert_equal 40, openings.count

      # Note this is based on the faked VCR cassette data
      assert_equal "Computer Software", staff_opening.title
      assert_equal 678305, staff_opening.api_id
      assert_equal "Wisconsin", staff_opening.state
      assert_equal false, staff_opening.private

      assert_equal 14, staff_opening.stages.count
      stage = staff_opening.stages.first
      assert_equal 5986001, stage.api_id
    end
  end
end
