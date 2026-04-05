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
      assert_equal false, staff_opening.is_private
      assert_equal "Object-based composite model", staff_opening.description
      assert_equal "Maine", staff_opening.location
      assert_equal "Full Time", staff_opening.position_type
      assert_equal true, staff_opening.is_remote_allowed
      assert_equal "berna_dietrich@huels.example", staff_opening.application_email
      assert_equal "http://batz.example/carrol_roberts", staff_opening.hosted_url
      assert_equal false, staff_opening.is_archived
      assert_equal "2025-01-15", staff_opening.created_at
      assert_equal "2025-09-11", staff_opening.updated_at
      assert_equal "2025-07-18", staff_opening.close_date
      assert_equal "typewriter", staff_opening.team

      assert_equal 2, staff_opening.additional_fields.count
      additional_field = staff_opening.additional_fields.first
      assert_equal "fugiat", additional_field.name
      assert_equal "consequatur", additional_field.value
      assert_equal true, additional_field.is_private

      assert_equal 14, staff_opening.stages.count
      assert_equal "Public Relations and Communications", staff_opening.title
      stage = staff_opening.stages.first
      assert_equal 5986001, stage.api_id
      assert_equal "quis", stage.name
      assert_equal false, stage.is_prospecting

      assert_equal 16, staff_opening.application_form_fields.count
      application_form_field = staff_opening.application_form_fields.first
      assert_equal "sunt", application_form_field.name
      assert_equal "hic", application_form_field.display_name
      assert_equal "aliquam", application_form_field.type
      assert_equal ["et", "dignissimos"], application_form_field.choices
      assert_equal false, application_form_field.is_required
      assert_equal false, application_form_field.is_disabled
    end
  end
end
