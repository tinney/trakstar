# frozen_string_literal: true

require "test_helper"

class CandidatesTest < Minitest::Test
  SSC_OPENING_ID = 254644
  TEST_CANDIDATE_ID = 34005534

  def test_candidates_can_be_fetched
    VCR.use_cassette("candidates") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidates = Trakstar.candidates

      assert_equal 6066, candidates.count

      candidate = candidates.first

      # These fields come from the vcr_cassettes/candidates.yml
      assert_equal 1, candidate.api_id
      assert_equal "Jaq", candidate.first_name
      assert_equal "Smith", candidate.last_name
      assert_equal "test@testdouble.com", candidate.email
      assert_equal 254644, candidate.opening_id
      assert_equal 2319011, candidate.stage_id
      assert_equal "Gem", candidate.source
    end
  end

  def test_candidate_can_be_fetched
    VCR.use_cassette("1_candidate") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidate = Trakstar.candidate(TEST_CANDIDATE_ID)

      candidate.labels

      assert_equal TEST_CANDIDATE_ID, candidate.api_id
      assert_equal ["Java", "React"], candidate.labels
    end
  end

  def test_candidate_can_be_created
    data = {
      :first_name => "Jaq",
      :last_name => "Smith",
      :email => "jaq.smith@testdouble.com",
      :source => "API Source",
      :opening_id => SSC_OPENING_ID,
      :age => "30",
      :location => "USA",
      :level => nil,
      "Skill 1" => ["Ruby", "JavaScript"],
      "Skill 2" => []
    }

    VCR.use_cassette("create_candidate") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidate = Trakstar.create_candidate(data)

      assert_equal 55255984, candidate.api_id
      assert_equal "Jaq", candidate.first_name
      assert_equal "Smith", candidate.last_name
    end
  end

  def xtest_candidate_can_be_updated
    data = {
      first_name: "Jac",
      last_name: "Perez",
      email: "jaq.perez@testdouble.com",
      source: "API",
      opening_id: 599766,
      age: "40",
      location: "USA"
    }

    VCR.use_cassette("update_candidate") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidate = Trakstar.update_candidate(TEST_CANDIDATE_ID, data)

      assert_equal 55242010, candidate.api_id
      assert_equal "Jac", candidate.first_name
    end
  end

  def test_candidate_raises_when_error
    data = {}

    VCR.use_cassette("create_candidate_error") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      Trakstar.create_candidate(data)
    rescue Trakstar::Error => e
      assert_equal "Error creating /candidates/: {\"email\":\"This field is required\",\"first_name\":\"This field is required\"}", e.message
    end
  end

  def xtest_candidate_delete
    VCR.use_cassette("delete_candidate") do
      candidate_id = 55280567
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      response = Trakstar.delete_candidate(candidate_id)
      assert_equal true, response
    end
  end

  def test_candidate_delete_error
    VCR.use_cassette("delete_candidate_error") do
      bad_id = 123456789
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      Trakstar.delete_candidate(bad_id)
    rescue Trakstar::Error => e
      assert_equal "Error deleting /candidates/123456789: {\"message\":\"The requested resource could not be found\"}", e.message
    end
  end
end
