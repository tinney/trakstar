module Trakstar
  class Evaluation < Models::Base
    attr_accessor :candidate_id, :stage_id, :opening_id, :interview_id, :interviewer_id, :overall_rating, :created_at, :interviewer_email
  end

  module Api
    class Evaluations
      EVALUATION_CRITERIA = "Overall Feedback"

      class << self
        def all(candidate_id)
          Http.get_all("/evaluations", query_params: {candidate_id: candidate_id}).map do |data|
            set!(Evaluation.new, data)
          end
        end

        def set!(evaluation, data)
          if (overall_feedback = data["feedback"]&.find { |feedback| feedback["evaluation_criteria"] == EVALUATION_CRITERIA })
            interviewer_id = overall_feedback.dig("submitted_by", "id")
            overall_rating = overall_feedback["rating"]
          else
            interviewer_id = nil
            overall_rating = nil
          end

          evaluation.tap do |evaluation|
            evaluation.api_id = data["id"]
            evaluation.candidate_id = data["candidate_id"]
            evaluation.interview_id = data["interview_id"]
            evaluation.stage_id = data["stage_id"]
            evaluation.opening_id = data["opening_id"]
            evaluation.created_at = data["date_submitted"]
            evaluation.interviewer_id = interviewer_id
            evaluation.overall_rating = overall_rating
            evaluation.interviewer_email = data.dig("feedback", 1, "submitted_by", "email") 
          end
        end
      end
    end
  end
end
