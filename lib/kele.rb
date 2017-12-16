require 'httparty'
require_relative 'roadmap'

class Kele

  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @email = email
    options = { body: { email: email, password: password } }
    response = self.class.post('/sessions', options)
    response["auth_token"] ? @auth_token = response["auth_token"] : puts(response["message"])
  end

  def get_me #return current user from Bloc API
    response = self.class.get("/users/me", headers: { "authorization" => @user_auth_code })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @user_auth_code })
    schedule = JSON.parse(response.body, symbolize_names: true)
  end

  def get_messages(page=nil)
    options = { headers: { "authorization" => @auth_token } }
    options.merge!({ body: { "page"=> page } }) unless page == nil
    response = self.class.get("/message_threads", options )
    messages = JSON.parse(response.body, symbolize_names: true)
  end

  def create_message(recipient_id, subject, stripped_text, token=nil)
    options = { headers: { "authorization" => @auth_token },
                body: {"sender" => @email,
                       "recipient_id" => recipient_id,
                       "stripped-text" => stripped_text,
                       "subject" => subject
                    }
              }
    options[:body][:token] = token if token
    response = self.class.post('/messages', options)
  end
end
