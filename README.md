# Trakstar

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/trakstar`. To experiment with that code, run `bin/console` for an interactive prompt.

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

```
      Trakstar.config(
        api_token: api_key,
        time_between_failed_requests: 60, # default 60 is used
        max_retry_attemps: 5 # default is 3, this is how many retries after a failed atempt
      )

      Trakstar.openings  # query to find all the openings
      Trakstar.candidates  # query to find all the candidates
```

## Running Test

In order to run the test suite run the `rake test` command

# Rate limit

100 requests per minute. Rate limits are inplace to sleep for .6 seconds if a multiple requests are made within a single second

# API

## Openings

```ruby
# Get all openings
Trakstar.openings

# Get a specific opening by ID
Trakstar.opening(id)
```

## Candidates

```ruby
# Get all candidates (supports optional parameters)
Trakstar.candidates(opening_id: 123, status: 'active')

# Get a specific candidate by ID
Trakstar.candidate(api_id)

# Create a new candidate
Trakstar.create_candidate(
  first_name: 'John',
  last_name: 'Doe',
  email: 'john.doe@example.com'
)

# Update an existing candidate
Trakstar.update_candidate(api_id, 
  first_name: 'Jane',
  status: 'hired'
)

# Delete a candidate
Trakstar.delete_candidate(api_id)
```

## Interviews

```ruby
# Get all interviews (optionally filter by candidate_id)
Trakstar.interviews
Trakstar.interviews(candidate_id)

# Get a specific interview by ID
Trakstar.interview(id)
```

## Reviews

```ruby
# Get all reviews (optionally filter by candidate_id)
Trakstar.reviews
Trakstar.reviews(candidate_id)
```

## Evaluations

```ruby
# Get all evaluations for a candidate
Trakstar.evaluations(candidate_id)

# Get a specific evaluation by ID
Trakstar.evaluation(id)
```

## Messages

```ruby
# Get all messages for a candidate
Trakstar.messages(candidate_id)
```

## Notes

```ruby
# Get all notes for a candidate
Trakstar.notes(candidate_id)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
