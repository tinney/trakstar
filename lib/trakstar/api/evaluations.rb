module Trakstar
  class Evaluation < Models::Base
    attr_accessor :candidate_id, :stage_id, :opening_id, :interview_id, :interviewer_id, :overall_rating, :created_at, :interviewer_email, :raw_data, :feedback
  end

  class Feedback
    attr_accessor :evaluation_criteria, :rating, :body
  end

  module Api
    class Evaluations
      EVALUATION_CRITERIA = "Overall Feedback"

      class << self
        def all(candidate_id)
          Http.get_all("/evaluations", query_params: {candidate_id: candidate_id}).map do |data|
            set!(Evaluation.new, data)
          end
        end

        def set!(evaluation, data)
          if (overall_feedback = data["feedback"]&.find { |feedback| feedback["evaluation_criteria"] == EVALUATION_CRITERIA })
            interviewer_id = overall_feedback.dig("submitted_by", "id")
            overall_rating = overall_feedback["rating"]
            date_submitted = overall_feedback["date_submitted"]
          elsif data["feedback"] && data["feedback"].any?
            first_feedback = data["feedback"].first
            interviewer_id = first_feedback.dig("submitted_by", "id")
            overall_rating = first_feedback["rating"]
            date_submitted = first_feedback["date_submitted"]
          else
            date_submitted = nil
            interviewer_id = nil
            overall_rating = nil
          end

          evaluation.tap do |evaluation|
            evaluation.raw_data = data
            evaluation.candidate_id = data["candidate_id"]
            evaluation.interview_id = data["interview_id"]
            evaluation.stage_id = data["stage_id"]
            evaluation.opening_id = data["opening_id"]
            evaluation.created_at = date_submitted
            evaluation.interviewer_id = interviewer_id
            evaluation.overall_rating = overall_rating
            evaluation.interviewer_email = data.dig("feedback", 1, "submitted_by", "email")
            evaluation.feedback = parse_feedback(data["feedback"])
          end
        end

        def parse_feedback(feedback_data)
          feedback_data.map do |fb_data|
            fb = Feedback.new
            fb.evaluation_criteria = fb_data["evaluation_criteria"]
            fb.rating = fb_data["rating"]
            fb.body = fb_data["body"]
            fb
          end
        end
      end
    end
  end
end


# {
#   "meta": {
#     "offset": 0,
#     "limit": 20,
#     "total": 1
#   },
#   "objects": [
#     {
#       "feedback": [
#         {
#           "evaluation_criteria": "Q1: How do they respond to an unexpected idea? Do they seek to establish understanding or are they only interested in their own ideas? Do they feel attacked easily?",
#           "rating": 0,
#           "body": "I found the conversation with Andy engaging and he showed genuine depth when we discussed complex topics like LLMs and neuro-symbolism. That said, I noticed most of our dialogue had Andy driving his own narrative rather than exploring ideas collaboratively. The story that stuck with me was when he described waiting for his manager to go on vacation before proceeding with an architecture change she had explicitly objected to. While he can accept other ideas, I'm not confident he naturally seeks them out or values them without prompting.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q2: Can you disagree productively? The Tim Wingfield test: make a change that's objectively bad, can they stay calm?",
#           "rating": 0,
#           "body": "I didn't run an explicit \"bad change\" test during our session. However, based on the stories Andy shared about past conflicts, I got the sense that he tends to push through opposition rather than work through it. He stayed calm and professional in our conversation, but his framing of past disagreements lacked empathy for other viewpoints. The way he talked about proceeding with the Kafka architecture while his manager was away suggests he's more comfortable circumventing disagreement than productively resolving it.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q3: Can they communicate effectively while pairing?",
#           "rating": -1,
#           "body": "I asked Andy to give me about five minutes of background on his resume and experience. He immediately launched into his story and talked for nearly fifteen minutes without pausing. I chose not to interrupt him because I genuinely wanted to hear his full narrative, but the lack of awareness about time boundaries and my needs as the audience was notable. Once we got into the code review and shifted into more dialogue, his communication improved significantly. Still, for client-facing consulting work where reading the room is essential, this initial signal concerns me.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q4: When you ask them a question about a technial area they're not yet comfortable in, would a client be comfortable with that response?",
#           "rating": 0,
#           "body": "I didn't have a clear opportunity to push Andy outside his technical comfort zone during our interview, so I don't have strong signal here.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q5: Do they get frustrated/angry/caremad while they work? Can they still be productive in that state?",
#           "rating": -1,
#           "body": "This is where my biggest concerns emerged. Throughout the interview, Andy repeatedly criticized former coworkers, at times calling them incompetent. The pattern appeared multiple times across different stories about his work history. The most striking example was the Kafka architecture story at Electronic Arts. His manager had objected to his proposal because she was concerned it would devalue another team's work, but Andy waited until she went on vacation to have conversations with that team anyway and implement his solution. He framed this as cutting through politics and said if he hadn't done it that way, the change would have gotten mired in technical battles. I can see the desire to drive change in a politically complex organization, but the way he communicated it showed a dismissive attitude toward legitimate organizational and interpersonal concerns. He explicitly told me he doesn't work well in political environments and that he tends to get bored. Combined with his quick job transitions and value judgments about non-tech companies not understanding good engineering, I'm concerned about his professional maturity and ability to navigate the normal complexity of client relationships.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q6: Do they have mastery of their editor / workflow?",
#           "rating": 1,
#           "body": "Andy demonstrated strong proficiency with Cursor and LLM-assisted development. I asked him to walk me through his prompting sessions, and after a slight hesitation he showed me his thought process. What I saw impressed me—he was surgical and precise in directing the LLM, getting exactly what he wanted efficiently. He had prepared a separate \"OCD branch\" to show me his refactoring work, which showed good workflow hygiene. The only minor detractor was that he's a self-described slow typer. When I suggested dictation tools, he joked that was a bridge he wasn't willing to cross. Overall though, his mastery of modern development tools is clear.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q7: Do they have mastery of a good set of tools (OS / throwaway scripting, debuggers, profilers, psql / sequel pro, regexes, etc.)",
#           "rating": 1,
#           "body": "Andy showed comfort with a broad range of contemporary tools. He introduced Rambda.js into his solution and used it effectively, demonstrating solid functional programming knowledge. His understanding of Kafka, GraphQL, and event-based architectures came through in our conversation about his past work. The intentional mix of imperative and functional programming styles in his code suggested flexibility in his approach rather than dogmatic adherence to one paradigm.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q8: Do they practice good code hygeine? Are their methods named well? Small enough? Clear?",
#           "rating": 1,
#           "body": "Andy's code quality was strong. Even before his LLM-assisted refactoring, the code was well-factored and clearly structured. He was thoughtful about when to use imperative versus functional styles, and his refactoring from procedural for-loops to Rambda utilities felt intentional rather than mechanical. The separate branch he prepared to walk me through his thinking demonstrated good organizational habits.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q9: Do they practice good test hygeine? Are their tests named well? Small enough? Clear? Organized?",
#           "rating": 0,
#           "body": "We didn't dive deep into testing practices during the interview. The signal I did get was positive—when our LLM refactoring caused four tests to fail, Andy immediately flagged it and said we should probably follow up on that if we had more time. This suggested good instincts about testing, but I don't have enough data to make a strong assessment.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q10: How well do they understand the different kinds of tests within a large test suite? How would you plan this on a larger project?",
#           "rating": 0,
#           "body": "We didn't explicitly discuss testing strategy across different layers. Andy did mention that our Cursor refactoring had broken four tests, and we had a brief conversation about using tests to gain confidence while working with LLMs. While we didn't get into the specifics of different test types, this gave me enough signal to believe he's got solid testing instincts. I'd want to probe this more in a follow-up if we proceed.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Q11: Were there any design red flags / weird approaches in their take home code?",
#           "rating": 1,
#           "body": "Andy's take-home submission showed thoughtful design. He prepared two versions—one before and one after his LLM-assisted refactoring—which demonstrated iterative thinking. His git workflow with purpose-driven branches was clean, and the functional patterns he used felt idiomatic and appropriate to the problem. The structure aligned well with the constraints of the exercise.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         },
#         {
#           "evaluation_criteria": "Overall Feedback",
#           "rating": -1,
#           "body": "I genuinely enjoyed talking with Andy. Our conversation stretched to almost ninety minutes because we got into fascinating territory about AI's impact on software development and the craft of coding. He's clearly smart, technically proficient, and has sophisticated thoughts about where the industry is heading. His capabilities with modern tools, especially LLM-assisted development, genuinely impressed me.\n\nMy concerns aren't about his intelligence or technical ability. They're about professional maturity and consulting readiness. The pattern of criticizing former colleagues, the story about circumventing his manager's authority, and his self-described difficulty with political environments all point to potential friction in client-facing work. When he talked about non-tech companies not understanding good engineering principles, or framed his manager's concerns about team dynamics as obstacles to be worked around rather than legitimate considerations, I saw someone who might struggle with the diplomacy and organizational navigation that consulting demands.\n\nThe question I'm left with is whether these are growth areas that coaching can address, or ingrained patterns that will create problems with clients and teammates. Given our bar for consulting roles and the competitive candidate pool, I'm inclined not to move forward unless we get compelling evidence from references that these concerns are either misread or actively being worked on. If we do proceed, I'd want the next round to explicitly test collaboration skills and probe more deeply into how Andy handles organizational complexity and builds bridges rather than burning them.\n\nI would not advocate strongly for moving Andy forward. The technical skills are there, but the interpersonal concerns are significant enough for a consulting role that I'd need to see strong contradicting evidence to change my assessment.",
#           "attachments": [],
#           "submitted_by": {
#             "id": 474509,
#             "name": "Dave Mosher",
#             "email": "dave.mosher@testdouble.com"
#           },
#           "date_submitted": 1761254538,
#           "is_locked": false
#         }
#       ],
#       "stage_id": 2329547,
#       "stage_name": "Take Home Interview",
#       "opening_id": 254644,
#       "opening_name": "Senior Software Consultant",
#       "interview_id": 4319881,
#       "candidate_id": 67170206
#     }
#   ]
# } 




