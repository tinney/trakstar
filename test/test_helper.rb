# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "trakstar"
require "vcr"
require "pry"
require "faker"
require "dotenv/load"

require "minitest/autorun"
require "vcr_data_filter"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock

  config.before_record do |i|
    i.response.body = VcrDataFilter.filter_body(i.response.body)
  end
end
