require "json"

class VcrDataFilter
  FILTERS = {
    Hash => ->(item_hash) { filter_hash(item_hash) },
    Array => ->(item_array) { filter_array(item_array) },
    String => ->(string) {},
    Integer => ->(integer) { Faker::Number.number(digits: 10) }
  }

  KEY_FILTERS = {
    "meta" => ->(values) { values },
    "id" => ->(id) { id },
    "opening_id" => ->(id) { id },
    "stage_id" => ->(id) { id },
    "created_at" => ->(date) { date },
    "updated_at" => ->(date) { date },
    "email" => ->(_) { Faker::Internet.email },
    "title" => ->(_) { Faker::Company.industry },
    "description" => ->(_) { Faker::Company.catch_phrase },
    "location" => ->(_) { Faker::Address.city },
    "position_type" => ->(_) { "Full Time" },
    "is_remote_allowed" => ->(_) { Faker::Boolean.boolean },
    "is_private" => ->(_) { Faker::Boolean.boolean },
    "is_archived" => ->(_) { Faker::Boolean.boolean },
    "application_email" => ->(_) { Faker::Internet.email },
    "hosted_url" => ->(_) { Faker::Internet.url },
    "created_date" => ->(_) { Faker::Date.in_date_period },
    "modified_date" => ->(_) { Faker::Date.in_date_period },
    "tags" => ->(_) { Faker::Hipster.words },
    "team" => ->(_) { Faker::Hipster.word },
    "state" => ->(_) { Faker::Address.state },
    "close_date" => ->(_) { Faker::Date.in_date_period }
  }

  class << self
    def filter_body(body)
      filter_hash(JSON.parse(body)).to_json
    rescue JSON::ParserError
      body
    end

    def filter_opening_data(key, value)
      if KEY_FILTERS.has_key?(key)
        KEY_FILTERS[key].call(value)
      elsif value.is_a?(Hash)
        filter_hash(value)
      elsif value.is_a?(Array)
        filter_array(value)
      elsif value.is_a?(String)
        Faker::Lorem.word
      elsif value.is_a?(Integer)
        Faker::Number.number(digits: 10)
      else
        value
      end
    end

    def filter_array(item_array)
      item_array.map do |item|
        filter_opening_data(nil, item)
      end
    end

    def filter_hash(item_hash)
      {}.tap do |new_hash|
        item_hash.each do |k, v|
          new_hash[k] = filter_opening_data(k, v)
        end
      end
    end
  end
end
