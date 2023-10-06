module Trakstar
  class Note < Models::Base
    attr_accessor :candidate_id, :sender_email, :body, :sent_at, :is_private, :recipient_emails
  end

  module Api
    class Notes
      class << self
        def all(candidate_id)
          Http.get_all("/internal_notes", query_params: {candidate_id: candidate_id}).map do |data|
            set!(Note.new, data)
          end
        end

        def set!(note, data)
          message = data.dig("messages", 0)
          note.tap do |note|
            note.api_id = data["id"]
            note.candidate_id = data.dig("candidate", "id")
            note.is_private = data["is_private"]
            note.sender_email = message.dig("sender", "email")
            note.body = message["body"]
            note.sent_at = message["date"]
            note.recipient_emails = data["recipients"].map { |r| r["email"] }
          end
        end
      end
    end
  end
end
