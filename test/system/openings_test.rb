# frozen_string_literal: true

require "test_helper"

class OpeningsTest < Minitest::Test
  def test_openings_can_be_fetched
    VCR.use_cassette("openings") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      openings = Trakstar.openings

      assert_equal 19, openings.count

      staff_opening = openings.first

      assert_equal "Investment Management", staff_opening.title
      assert_equal 465483, staff_opening.api_id
      assert_equal "Published", staff_opening.state
      assert_equal false, staff_opening.private

      assert_equal 15, staff_opening.stages.count

      stage = staff_opening.stages.first
      assert_equal 0, stage.position
      assert_equal 4093864, stage.api_id
    end
  end
end
