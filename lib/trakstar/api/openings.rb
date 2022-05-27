module Trakstar
  class Opening < Models::Base
    attr_accessor :title, :state, :private, :tags
    synced_attr_accessor :stages
  end

  class Stage < Models::Base
    attr_accessor :position, :name, :type
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
        opening.loaded!
      end

      def self.find(api_id)
        data = Http.get("/openings/#{api_id}")
        Opening.new.tap do |opening|
          set!(opening, data)
          opening.loaded!
        end
      end

      def self.set!(opening, data)
        opening.tap do |opening|
          opening.title = data["title"]
          opening.api_id = data["id"]
          opening.state = data["state"]
          opening.tags = data["tags"]
          opening.private = data["is_private"]
          opening.stages = build_stages(data["stages"]) if data.key?("stages")
          opening.sync = -> { sync(opening) }
        end
      end

      def self.build_stages(stages_data)
        stages_data.map do |stage_data|
          Stage.new.tap do |stage|
            stage.api_id = stage_data["id"]
            stage.name = stage_data["name"]
            stage.type = stage_data["type"]
            stage.position = stage_data["position"]
          end
        end
      end
    end
  end
end
