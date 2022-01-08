require 'json'

class VcrDataFilter
  FAKER_MAP = {
    "id" => -> { Faker::Number.number(digits: 4) },
    "title" => -> { Faker::Company.industry },
    "description" => -> { Faker::Company.catch_phrase },
    "location" => -> { Faker::Address.city },
    "position_type" => -> { "Full Time" },
    "is_remote_allowed" => -> { Faker::Boolean.boolean },
    "is_private" => -> { Faker::Boolean.boolean },
    "is_archived" => -> { Faker::Boolean.boolean },
    "application_email" => -> { Faker::Internet.email },
    "hosted_url" => -> { Faker::Internet.url },
    "created_date" => -> {Faker::Date.in_date_period } ,
    "modified_date" => -> { Faker::Date.in_date_period },
    "tags" => -> { Faker::Hipster.words },
    "team" => -> { Faker::Hipster.word },
    "state" => -> { Faker::Address.state },
    "close_date" => -> { Faker::Date.in_date_period },
    "type" => -> { {"name"=>"zoom", "metadata"=>{"meeting_url"=>"https://us06web.zoom.us/j/1234", "password"=>"N/A", "meeting_id"=>"1234"}}},
    "created_by" => -> { {"id"=> Faker::Number.number(digits: 4), "name"=>"Jim Jones", "email"=>"jjones@testdouble.com"} },
    "invitees" => -> { [{"name"=>"Jim Jones", "email"=>"jjones@testdouble.com"}] }
  }

  class << self
    def filter_body(body)
      filter_opening_data(JSON.parse(body)).to_json
    end


    def filter_opening_data(body)
      if body["objects"]
        objects = body["objects"].map { |body_object| mask_body(body_object) }
        { "meta" => body["meta"], "objects" => objects}
      else
        mask_body(body)
      end
    end

    def mask_body(resource)
      if resource.is_a?(Array)
      elsif resource.is_a?(Hash)
      else
        {}.tap do |masked| 
          body.keys.each do |attribute| 
            masked[attribute] = FAKER_MAP.key?(attribute) ? FAKER_MAP[attribute].call : body[attribute]
          end
        end
      end
    end
  end
end