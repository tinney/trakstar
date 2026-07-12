require "test_helper"
require "stringio"

class HttpLoggingTest < Minitest::Test
  def setup
    @io = StringIO.new
    @logger = Logger.new(@io, level: Logger::DEBUG)
  end

  def test_debug_flag_persists_across_config_reads
    Trakstar.config(debug: true)

    # Trakstar.config re-runs Config#set on every access, so an unguarded
    # assignment would silently reset the flag here.
    assert_equal true, Trakstar.config.debug
  ensure
    Trakstar.config(debug: false)
  end

  def test_logs_method_url_and_attributes_when_debug_enabled
    Trakstar.config(debug: true, logger: @logger)

    Trakstar::Http.send(:log_request, "POST", URI("https://api.recruiterbox.com/v2/candidates/"), {first_name: "Jaq"})

    assert_match(/\[Trakstar\] POST https:\/\/api\.recruiterbox\.com\/v2\/candidates\//, @io.string)
    assert_match(/attributes=.*first_name.*Jaq/, @io.string)
  ensure
    Trakstar.config(debug: false)
  end

  def test_logs_url_without_attributes_section_when_none_given
    Trakstar.config(debug: true, logger: @logger)

    Trakstar::Http.send(:log_request, "GET", URI("https://api.recruiterbox.com/v2/candidates/1"))

    assert_match(/\[Trakstar\] GET https:\/\/api\.recruiterbox\.com\/v2\/candidates\/1/, @io.string)
    refute_match(/attributes=/, @io.string)
  ensure
    Trakstar.config(debug: false)
  end

  def test_does_not_log_when_debug_disabled
    Trakstar.config(debug: false, logger: @logger)

    Trakstar::Http.send(:log_request, "GET", URI("https://api.recruiterbox.com/v2/candidates/1"))

    assert_empty @io.string
  end

  def test_logs_real_request_through_http_layer
    VCR.use_cassette("1_candidate") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"], debug: true, logger: @logger)
      Trakstar.candidate(34005534)

      assert_match(/\[Trakstar\] GET https:\/\/api\.recruiterbox\.com\/v2\/candidates\/34005534/, @io.string)
    end
  ensure
    Trakstar.config(debug: false)
  end
end
