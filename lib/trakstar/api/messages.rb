module Trakstar
  class Message < Models::Base
    attr_accessor :candidate_id, :sender_email, :created_at, :subject
  end

  module Api
    class Messages
      class << self
        def all(candidate_id)
          Http.get_all("/candidate_messages", query_params: {candidate_id: candidate_id}).map do |data|
            create_messages(data)
          end.flatten
        end

        def create_messages(data)
          data["messages"].map do |message_data|
            Message.new.tap do |message|
              message.api_id = data["id"]
              message.candidate_id = data.dig("candidate", "id")
              message.sender_email = message_data.dig("sender", "email")
              message.created_at = message_data["date"]
              message.subject = message_data["subject"]
            end
          end
        end
      end
    end
  end
end
