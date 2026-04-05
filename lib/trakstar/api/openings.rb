module Trakstar
  class Opening < Models::Base
    synced_attr_accessor :title, :description, :team, :state, :position_type,
                         :is_remote_allowed, :location, :location_city,
                         :location_state, :location_zipcode, :location_country,
                         :private, :is_private, :hosted_url, :application_email,
                         :is_archived, :created_at, :updated_at, :close_date,
                         :tags, :stages, :application_form_fields,
                         :additional_fields
  end

  class Stage < Models::Base
    attr_accessor :position, :name, :type, :is_prospecting
  end

  class ApplicationFormField < Models::Base
    attr_accessor :name, :display_name, :type, :choices,
                  :is_required, :is_disabled, :position
  end

  class AdditionalField < Models::Base
    attr_accessor :name, :value, :is_private
  end

  module Api
    module Openings
      def self.all
        Http.get_all("/openings").map do |data|
          set!(Opening.new, data)
        end
      end

      def self.sync(opening)
        data = Http.get("/openings/#{opening.api_id}")
        set!(opening, data)
      end

      def self.find(api_id)
        data = Http.get("/openings/#{api_id}")
        Opening.new.tap do |opening|
          set!(opening, data)
        end
      end

      def self.set!(opening, data)
        opening.tap do |opening|
          opening.api_id = data["id"]
          opening.title = data["title"]
          opening.description = data["description"]
          opening.team = data["team"]
          opening.state = data["state"]
          opening.position_type = data["position_type"]
          opening.is_remote_allowed = data["is_remote_allowed"]

          location_data = data["location"]
          opening.location = location_data
          if location_data.is_a?(Hash)
            opening.location_city = location_data["city"]
            opening.location_state = location_data["state"]
            opening.location_zipcode = location_data["zipcode"]
            opening.location_country = location_data["country"]
          end

          opening.private = data["is_private"]
          opening.is_private = data["is_private"]
          opening.hosted_url = data["hosted_url"]
          opening.application_email = data["application_email"]
          opening.is_archived = data["is_archived"]
          opening.created_at = data["created_date"]
          opening.updated_at = data["modified_date"]
          opening.close_date = data["close_date"]
          opening.tags = data["tags"]

          opening.stages = build_stages(data["stages"]) if data.key?("stages")
          if data.key?("application_form_fields")
            opening.application_form_fields = build_application_form_fields(data["application_form_fields"])
          end
          if data.key?("additional_fields")
            opening.additional_fields = build_additional_fields(data["additional_fields"])
          end

          opening.sync = -> { sync(opening) }
        end
      end

      def self.build_stages(stages_data)
        stages_data.map do |stage_data|
          Stage.new.tap do |stage|
            stage.api_id = stage_data["id"]
            stage.name = stage_data["name"]
            stage.type = stage_data["type"]
            stage.is_prospecting = stage_data["is_prospecting"]
            stage.position = stage_data["position"]
          end
        end
      end

      def self.build_application_form_fields(application_form_fields_data)
        application_form_fields_data.map do |field_data|
          ApplicationFormField.new.tap do |field|
            field.name = field_data["name"]
            field.display_name = field_data["display_name"]
            field.type = field_data["type"]
            field.choices = field_data["choices"]
            field.is_required = field_data["is_required"]
            field.is_disabled = field_data["is_disabled"]
            field.position = field_data["position"]
          end
        end
      end

      def self.build_additional_fields(additional_fields_data)
        additional_fields_data.map do |field_data|
          AdditionalField.new.tap do |field|
            field.name = field_data["name"]
            field.value = field_data["value"]
            field.is_private = field_data["is_private"]
          end
        end
      end
    end
  end
end
