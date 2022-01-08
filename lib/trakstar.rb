# frozen_string_literal: true

require_relative "trakstar/version"
require_relative "trakstar/config"
require_relative "trakstar/http"
require_relative "trakstar/model"
require_relative "trakstar/api/openings"
require_relative "trakstar/api/candidates"
require_relative "trakstar/api/interviews"
require_relative "trakstar/api/reviews"
require_relative "trakstar/api/evaluations"
require_relative "trakstar/api/messages"
require_relative "trakstar/api/notes"

module Trakstar
  class Error < StandardError; end

  def self.config(**attrs)
    (@config ||= Config.new).tap do |config|
      config.set(**attrs)
    end
  end

  def self.openings
    Api::Openings.all
  end

  def self.opening(id)
    Api::Openings.find(id)
  end

  def self.candidates(**params)
    Api::Candidates.all(**params)
  end

  def self.candidate(id)
    Api::Candidates.find(id)
  end

  def self.interviews(candidate_id)
    Api::Interviews.all(candidate_id)
  end

  def self.interview(id)
    Api::Interviews.find(id)
  end

  def self.reviews(candidate_id)
    Api::Reviews.all(candidate_id)
  end

  def self.evaluations(candidate_id)
    Api::Evaluations.all(candidate_id)
  end

  def self.evaluation(id)
    Api::Evaluations.find(id)
  end

  def self.messages(candidate_id)
    Api::Messages.all(candidate_id)
  end

  def self.notes(candidate_id)
    Api::Notes.all(candidate_id)
  end
end
