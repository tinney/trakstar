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

  def test_candidate_can_be_created
    data = {
      first_name: "Jaq", 
      last_name: "Smith",
      email: "jaq.smith@testdouble.com",
      source: "API Source", 
      opening_id: 599766, 
      age: "30",
      location: "USA",
      level: nil,
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

  def test_candidate_can_be_updated
    candidate_id = 55242010 
    data = {
      first_name: "Jac", 
      last_name: "Perez",
      email: "jaq.perez@testdouble.com",
      source: "API", 
      opening_id: 599766, 
      age: "40",
      location: "USA",
    }

    VCR.use_cassette("update_candidate") do
      Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
      candidate = Trakstar.update_candidate(candidate_id, data)

      assert_equal 55242010, candidate.api_id
      assert_equal "Jac", candidate.first_name
    end
  end

  def test_candidate_raises_when_error
    data = { }

    VCR.use_cassette("create_candidate_error") do
      begin
        Trakstar.config(api_token: ENV["TRAKSTAR_API_KEY"])
        Trakstar.create_candidate(data)
      rescue Trakstar::Error => e
        assert_equal "Error creating /candidates/: {\"email\": \"This field is required\", \"first_name\": \"This field is required\"}", e.message
      end
    end
  end
end
