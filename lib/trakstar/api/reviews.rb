module Trakstar
  class Review < Models::Base
    attr_accessor :candidate_id, :reviewer_email, :comment, :created_at
  end

  module Api
    class Reviews
      class << self
        def all(candidate_id)
          Http.get_all("/reviews", query_params: {candidate_id: candidate_id}).map do |data|
            set!(Review.new, data)
          end
        end

        def set!(review, data)
          review.tap do |review|
            review.api_id = data["id"]
            review.candidate_id = data.dig("candidate", "id")
            review.reviewer_email = data.dig("reviewers", 0, "email")
            review.comment = data.dig("comments", 0, "message")
            review.created_at = data["date_created"]
            review.feedback = data["feedback"]
          end
        end
      end
    end
  end
end
