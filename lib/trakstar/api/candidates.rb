module Trakstar
  class Candidate < Models::Base
    attr_accessor :first_name, :last_name, :email, :stage_id, :opening_id, :created_at, :updated_at, :source, :source_type, :labels
    synced_attr_accessor :state, :primary_language, :secondary_language, :profile_data, :resume_url, :labels
  end

  module Api
    class Candidates
      class << self
        def all(**query_params)
          Http.get_all("/candidates", query_params: query_params).map do |data|
            set!(Candidate.new, data)
          end
        end

        def find(api_id)
          data = Trakstar::Http.get("/candidates/#{api_id}")
          Candidate.new.tap do |candidate|
            set!(candidate, data)
            candidate.loaded!
          end
        end

        # TODO replace with find
        def sync(model)
          data = Http.get("/candidates/#{model.api_id}")
          set!(model, data)
          model.loaded!
          model
        end

        def set!(candidate, data)
          labels = data.dig("labels") || []
          candidate.tap do |candidate|
            candidate.api_id = data["id"]
            candidate.email = data["email"]
            candidate.first_name = data["first_name"]
            candidate.last_name = data["last_name"]
            candidate.opening_id = data["opening_id"]
            candidate.created_at = data["created_date"]
            candidate.updated_at = data["updated_date"]
            candidate.state = data["state"]
            candidate.stage_id = data["stage_id"]
            candidate.labels = labels.map { |l| l["name"] }
            candidate.sync = -> { sync(candidate) }
            candidate.profile_data = data["profile_data"]
            candidate.resume_url = data.dig("resume", "file_url")
            candidate.source = data["source"]
            candidate.source_type = data["source_type"]
          end
        end
      end
    end
  end
end
