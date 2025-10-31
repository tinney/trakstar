module Trakstar
  class Candidate < Models::Base
    synced_attr_accessor :first_name, :last_name, :email, :phone, :description, :stage_id, :opening_id, :created_at, :updated_at, :source, :source_type, :labels, :state, :primary_language, :secondary_language, :profile_data, :resume_url
  end

  module Api
    class Candidates
      class << self
        def delete(api_id)
          Http.delete("/candidates/#{api_id}")
        end

        def update(api_id, attributes)
          data = Http.patch("/candidates/#{api_id}", format_attributes_for_api(attributes))

          Candidate.new.tap do |candidate|
            set!(candidate, data)
          end
        end

        def create(attributes)
          data = Http.post("/candidates/", format_attributes_for_api(attributes))

          Candidate.new.tap do |candidate|
            set!(candidate, data)
          end
        end

        def format_attributes_for_api(attributes)
          attrs = {}
          attributes.dup.tap do |source|
            attrs[:first_name] = source.delete(:first_name)
            attrs[:last_name] = source.delete(:last_name)
            attrs[:email] = source.delete(:email)
            attrs[:source] = source.delete(:source)
            attrs[:opening_id] = source.delete(:opening_id)
            attrs[:stage_id] = source.delete(:stage_id)
            attrs[:description] = source.delete(:description)
            attrs[:phone] = source.delete(:phone)
            attrs[:profile_data] = []
            attrs[:profile_data] = source.map { |key, value| {name: key.to_s, value: value.to_s} }
          end

          attrs
        end

        def all(**query_params)
          Http.get_all("/candidates", query_params: query_params).map do |data|
            set!(Candidate.new, data)
          end
        end

        def find(api_id)
          data = Trakstar::Http.get("/candidates/#{api_id}")
          Candidate.new.tap do |candidate|
            set!(candidate, data)
          end
        end

        # TODO replace with find
        def sync(model)
          data = Http.get("/candidates/#{model.api_id}")
          set!(model, data)
          model
        end

        def set!(candidate, data)
          labels = data.dig("labels") || []
          candidate.tap do |candidate|
            candidate.api_id = data["id"]
            candidate.email = data["email"]
            candidate.first_name = data["first_name"]
            candidate.last_name = data["last_name"]
            candidate.phone = data["phone"]
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
