require "httparty"
require "json"
require "./lib/roadmap.rb"

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    @email = email
    @base_api_url = "https://www.bloc.io/api/v1"
    response = self.class.post(@base_api_url + "/sessions", body: { "email": email, "password": password })

    raise "Invalid email or password" unless response.code == 200

    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(@base_api_url + '/users/me', headers: { "authorization" => @auth_token })

    raise "Unable to retrieve User Data" unless response.code == 200

    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(@base_api_url + "/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })

    raise "Unable to retrieve mentor's availability" unless response.code == 200

    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page = nil)
    if page
      response = self.class.get(@base_api_url + "/message_threads", body: { "page": page }, headers: { "authorization" => @auth_token })
    else
      response = self.class.get(@base_api_url + "/message_threads", headers: { "authorization" => @auth_token })
    end

    raise "Unable to retrieve messages" unless response.code == 200

    @messages = JSON.parse(response.body)
  end

  def create_message(mentor_id, message)
    options = {
      "sender": @email,
      "recipient_id": mentor_id,
      "stripped-text": message
    }

    response = self.class.post(@base_api_url + "/messages", body: options, headers: { "authorization" => @auth_token })

    raise "Unable to send message" unless response.code == 200

    if response.success?
      puts "message sent!"
    end
  end
end
