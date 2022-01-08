# Trakstar

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/trakstar`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trakstar'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install trakstar

## Usage

# Rate limit
# Pagination

class BackloadingStruct < Struct
    def self.requires_backload(attr_names)
        attr_names.each define_method
          if loaded?
            return instance_variable_get("@#{attr_name}")
        else
            load_detail!
        end
    end
end

Class Opening
    requires_backload :stages, :thing, :whatever

    def load_detail
        res = @connection.opening(@id)
        @stages = res["stages"].map { |stage| Stage.new() }
        @loaded = true
        end
end

Class Stage
end


>
opening = Trakstar::Opening.new

conn = Trakstar.new(api_key: "x")
conn.get_openings # load all openings
conn.get_opening(id) # load one opening

conn.candidates
conn.candidates(opening: :opening_id)
conn.candidates(state: :active)
conn.candidate(id)

conn.interviews # free floating object w/ no opening or stage knowledge
conn.interviews(candidate_id: :candidate_id) # free floating object w/ no opening or stage knowledge
conn.interview(id) # free floating object w/ no opening or stage knowledge


Opening has_many => Stages 
Stage => has_many :interviews (we lose id stage_id, candidate_id)
Evaluation => interview has_many evaluations (we lose ids)

Trakstar::Opening.all
# Openings fetch
# stages call will trigger an Opening.show(:trakstar_id)

Trakstar::Opening.get({:trakstar_id})
Trakstar::Opening.show({:trakstar_id})

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
