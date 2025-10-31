module Trakstar
  class Interview < Models::Base
    synced_attr_accessor :title, :description, :scheduled_at, :duration, :location, :created_at, :is_cancelled, :candidate_id, :interviewer_email, :interviewer_id
  end

  module Api
    class Interviews
      class << self
        def all(candidate_id = nil)
          query_params = candidate_id ? {candidate_id: candidate_id} : {}
          Http.get_all("/interviews", query_params: query_params).map do |data|
            set!(Interview.new, data)
          end
        end

        def find(api_id)
          data = Trakstar::Http.get("/interviews/#{api_id}")
          Interview.new.tap do |interview|
            set!(interview, data)
          end
        end

        def sync(model)
          data = Http.get("/interviews/#{model.api_id}")
          set!(model, data)
          model
        end

        def set!(interview, data)
          interview.tap do |interview|
            interview.api_id = data["id"]
            interview.title = data["title"]
            interview.description = data["description"]
            interview.scheduled_at = data["time"]
            interview.created_at = data["date_created"]
            interview.is_cancelled = data["is_cancelled"]
            interview.candidate_id = data.dig("candidate", "id")
            interview.interviewer_email = data.dig("created_by", "email")
            interview.interviewer_id = data.dig("created_by", "id")
            interview.sync = -> { sync(interview) }
          end
        end
      end
    end
  end
end
